class Atrium::Showcase < ActiveRecord::Base
  self.table_name = 'atrium_showcases'

  # TODO: remove the need to expose the showcase_id to the AtriumShowcasesController
  attr_accessible(
    :showcases_id,
    :showcases_type,
    :showcase_items,
    :solr_facet_name,
    :value,
    :descriptions_attributes,
    :facet_selections_attributes,
    :featured_items_attributes,
    :related_items_attributes
  )

  has_many(
    :descriptions,
    :class_name => 'Atrium::Description',
    :foreign_key => 'atrium_showcase_id',
    :dependent => :destroy
  )
  accepts_nested_attributes_for(
    :descriptions,
    :allow_destroy => true
  )

  has_many(
    :facet_selections,
    :class_name => 'Atrium::Showcase::FacetSelection',
    :foreign_key => 'atrium_showcase_id',
    :dependent => :destroy
  )
  accepts_nested_attributes_for :facet_selections

  def get_parent_path
    if for_exhibit?
      facet={}
      unless facet_selections.blank?
        facet[facet_selections.first.solr_facet_name]=facet_selections.first.value
      end
      path= Rails.application.routes.url_helpers.atrium_exhibit_path(parent, :f=>facet)
      return path
    else
      return parent
    end
  end

  has_many(
    :featured_items,
    :class_name => 'Atrium::Showcase::Item::Featured',
    :foreign_key => 'atrium_showcase_id',
    :dependent => :destroy
  )
  accepts_nested_attributes_for(
    :featured_items,
    :allow_destroy => true
  )

  has_many(
    :related_items,
    :class_name => 'Atrium::Showcase::Item::Related',
    :foreign_key => 'atrium_showcase_id',
    :dependent => :destroy
  )
  accepts_nested_attributes_for(
    :related_items,
    :allow_destroy => true
  )

  belongs_to(
    :showcases,
    :polymorphic => true
  )

  serialize :showcase_items, Hash

  def showcase_items
    read_attribute(:showcase_items) || write_attribute(:showcase_items, {})
  end

  def solr_doc_ids
    showcase_items[:solr_doc_ids] unless showcase_items.blank?
  end

  def type
    showcase_items[:type] unless showcase_items.blank?
  end

  def parent
    if showcases_type && showcases_id
      begin
        showcases_type.constantize.find(showcases_id)
      rescue
        logger.error("Invalid showcase parent type set for showcase id: #{id}")
        nil
      end
    end
  end

  def parent_title
    parent.pretty_title
  end

  def for_exhibit?
    showcases_type == "Atrium::Exhibit"
  end

  # This method will select showcase objects that have exactly the selected facets passed in (but no more or no less) and is tied to the given exhibit id
  # It expects two parameters:
  # @param[String] the exhibit id
  # @param[Hash] hash of key value pairs of selected facets
  # @return Array of showcase objects found
  scope :with_selected_facets, lambda {|*args|
    parent_id, parent_type, selected_facets = args.flatten(1)

    selected_facets =
    if parent_type.eql?("Atrium::Collection")
      {}
    else
      selected_facets
    end
    facet_condition_values = []
    facet_conditions =
    if selected_facets
      selected_facets.collect {|key,value|
        facet_condition_values << key
        facet_condition_values << value.is_a?(String) ? value : value.flatten

        %((
          #{Atrium::Showcase::FacetSelection.quoted_table_name}.`solr_facet_name` = '#{key}'
          AND #{Atrium::Showcase::FacetSelection.quoted_table_name}.`value` = '#{value}'
         ))
      }
    else
      []
    end

    if facet_conditions.empty?
      joins(%(
        LEFT OUTER JOIN #{Atrium::Showcase::FacetSelection.quoted_table_name}
        ON #{quoted_table_name}.`id` = #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`)
      ).
      where(:showcases_id => parent_id,:showcases_type => parent_type).
      where("#{Atrium::Showcase::FacetSelection.quoted_table_name}.`id` is NULL")
    else
      # unfortunately have to do subselect here to get this correct
      # require 'ruby-debug'; debugger
      conditions = [%(
        #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`
        IN (
          SELECT #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`
          FROM #{Atrium::Showcase::FacetSelection.quoted_table_name}
          INNER JOIN #{quoted_table_name}
          ON #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id` = #{quoted_table_name}.`id`
          WHERE #{quoted_table_name}.showcases_id = #{parent_id}
          AND #{quoted_table_name}.`showcases_type` = \"#{parent_type}\"
          AND (#{facet_conditions.join(" OR ")})
        )
      )]# + facet_condition_values

      having_str = %(
        COUNT(#{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`) = #{facet_conditions.size}
      )

      joins(:facet_selections).
      where(conditions).
      group("#{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`").
      having(having_str)
    end
  }

end
