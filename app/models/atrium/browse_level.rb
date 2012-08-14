module Atrium
  class BrowseLevel < ActiveRecord::Base
    attr_accessible(
        :atrium_exhibit_id,
        :exclude_query_params,
        :filter_query_params,
        :level_number,
        :solr_facet_name,
        :label
    )

    validates_presence_of(
        :atrium_exhibit_id,
        :solr_facet_name
    )

    belongs_to(
        :exhibit,
        :class_name => 'Atrium::Exhibit',
        :foreign_key => 'atrium_exhibit_id'
    )


    serialize :filter_query_params

    serialize :exclude_query_params

    attr_accessor :selected
    attr_writer :values

    def values
      @values ||= []
    end

    def to_s
      "#{solr_facet_name}"
    end
    before_create :assign_level_number

    private
    def assign_level_number
      if self.level_number.blank?
        self.level_number= exhibit.browse_levels.size + 1
      end
    end
  end
end
