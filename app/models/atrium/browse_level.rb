class Atrium::BrowseLevel < ActiveRecord::Base
  self.table_name = 'atrium_browse_levels'

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
    :level_number,
    :solr_facet_name
  )

  belongs_to(
    :exhibit,
    :class_name => 'Atrium::Exhibit',
    :foreign_key => 'atrium_exhibit_id'
  )


  serialize :filter_query_params

  serialize :exclude_query_params

  attr_accessor :values, :selected

  def values
    @values ||= []
  end

  def to_s
    "#{solr_facet_name}"
  end

end
