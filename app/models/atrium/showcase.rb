module Atrium
  class Showcase < ActiveRecord::Base
    attr_accessible(
        :showcases_id,
        :showcases_type,
        :showcase_items,
        :tag,
        :sequence,
        :solr_facet_name,
        :value,
        :descriptions_attributes,
        :facet_selections_attributes
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

    def facet_details
      logger.debug("Belongs to: #{facet_selections.inspect}")
      "#{facet_selections.solr_facet_name - facet_selections.value}"
    end



    belongs_to(
        :showcases,
        :polymorphic => true
    )

    serialize :showcase_items, Hash

    def showcase_items
      items=read_attribute(:showcase_items) || write_attribute(:showcase_items, {})
      if items && items[:solr_doc_ids]
        items[:solr_doc_ids].split(",")
      else
        []
      end
    end

    def showcase_items=(solr_doc_ids = [])
      unless solr_doc_ids.blank?
        items={}
        items[:type]="featured"
        items[:solr_doc_ids]=solr_doc_ids.join(',')
        write_attribute(:showcase_items, items)
      else
        write_attribute(:showcase_items, {})
      end

    end

    def solr_doc_ids
      showcase_items[:solr_doc_ids] unless showcase_items.blank?
    end

    def type
      showcase_items[:type] unless showcase_items.blank?
    end

    after_create :assign_sequence

    def assign_sequence
      unless for_exhibit?
        sequence= parent.showcases.size
        self.update_attributes(:sequence => sequence)
      end
    end

    def pretty_title
      id.blank? ? 'Unnamed Showcase' : "Showcase #{id}"
    end



    # This method will select showcase objects that have exactly the selected facets passed in (but no more or no less) and is tied to the given exhibit id
    # It expects two parameters:
    # @param[String] the exhibit id
    # @param[Hash] hash of key value pairs of selected facets
    # @return Array of showcase objects found
    scope :with_selected_facets, lambda {|*args|
      parent_id, parent_type, selected_facets = args.flatten(1)
      logger.debug("Selected_facet:#{selected_facets.inspect}")
      selected_facets =
          if parent_type.eql?("Atrium::Collection")
            {}
          else
            selected_facets
          end
      facet_condition_values = []
      logger.debug("facet_condition_values:#{facet_condition_values.inspect}")
      facet_conditions =
          if selected_facets
            selected_facets.collect {|key,value|
              logger.debug("Value class: #{value.class}, Value:#{value.to_s}, facet_condition_values:#{(value.is_a?(String) ? value : value.flatten.compact.first.to_s).inspect}")
              facet_condition_values << key
              facet_condition_values << (value.is_a?(String) ? value : value.flatten.compact.first.to_s)

              %((
          #{Atrium::Showcase::FacetSelection.quoted_table_name}.`solr_facet_name` = ?
          AND #{Atrium::Showcase::FacetSelection.quoted_table_name}.`value` = ?
         ))
            }
          else
            []
          end
      logger.debug("facet_conditions:#{facet_conditions.inspect}, facet_condition_values:#{facet_condition_values.inspect}")
      if facet_conditions.empty?
        joins(%(
        LEFT OUTER JOIN #{Atrium::Showcase::FacetSelection.quoted_table_name}
        ON #{quoted_table_name}.`id` = #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`)
        ).
            where(:showcases_id => parent_id,:showcases_type => parent_type).
            where("#{Atrium::Showcase::FacetSelection.quoted_table_name}.`id` is NULL")
      else
        # unfortunately have to do subselect here to get this correct
        conditions = [%(
                      #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`
        IN (
          SELECT #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id`
          FROM #{Atrium::Showcase::FacetSelection.quoted_table_name}
          INNER JOIN #{quoted_table_name}
          ON #{Atrium::Showcase::FacetSelection.quoted_table_name}.`atrium_showcase_id` = #{quoted_table_name}.`id`
          WHERE #{quoted_table_name}.showcases_id = ?
          AND #{quoted_table_name}.`showcases_type` = ?
          AND (#{facet_conditions.join(" OR ")})
        )
      ), parent_id, parent_type, ] + facet_condition_values

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
end
