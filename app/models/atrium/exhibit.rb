module Atrium
  class Exhibit < ActiveRecord::Base
    attr_accessible(
        :atrium_collection_id,
        :filter_query_params,
        :label,
        :set_number,
        :browse_levels_attributes,
        :showcases_attributes
    )

    belongs_to(
        :collection,
        :class_name => 'Atrium::Collection',
        :foreign_key => 'atrium_collection_id'
    )

    has_many(
        :showcases,
        :class_name => 'Atrium::Showcase',
        :as => :showcases
    )
    accepts_nested_attributes_for :showcases


    has_many(
        :browse_levels,
        :class_name => 'Atrium::BrowseLevel',
        :foreign_key => 'atrium_exhibit_id',
        :order => 'level_number ASC'
    )

    accepts_nested_attributes_for :browse_levels, :allow_destroy => true
    def browse_facet_names
      browse_levels.collect {|facet| facet.solr_facet_name} rescue []
    end

    def browse_level_order
      facet_order = {}
      browse_levels.map{|facet| facet_order[facet[:id]] = facet.level_number }
      facet_order
    end

    def browse_level_order=(facet_order = {})
      valid_ids = browse_levels.select(:id).map{|facet| facet[:id]}
      facet_order.each_pair do |id, order|
        Atrium::BrowseLevel.find(id).update_attributes!(:level_number => order) if valid_ids.include?(id.to_i)
      end
    end


    serialize :filter_query_params

    def pretty_title
      label.blank? ? "Exhibit #{set_number}" : label
    end

    def get_available_facets
      collection.search_facet_names - browse_facet_names
    end

    before_create :assign_set_number

    private
    def assign_set_number
      if collection
        self.set_number= collection.exhibits.size + 1
      end
    end
  end
end
