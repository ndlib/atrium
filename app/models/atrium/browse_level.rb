# Maps to a facet, when rendered it renders a collection of solr documents.
# Each solr document rendered this way, may have a unique showcase associated
# with it.
class Atrium::BrowseLevel < ActiveRecord::Base
  attr_accessible(
    :atrium_exhibit_id,
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
    class_name: 'Atrium::Exhibit',
    foreign_key: 'atrium_exhibit_id'
  )

  include Atrium::QueryParamMixin

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

  def label
    if read_attribute(:label).present?
      read_attribute(:label)
    else
      Atrium.config.label_for_facet(solr_facet_name)
    end
  end

  private
  def assign_level_number
    if self.level_number.blank?
      self.level_number= exhibit.browse_levels.size + 1
    end
  end
end
