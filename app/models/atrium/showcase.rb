class Atrium::Showcase < ActiveRecord::Base
  has_many :featured_items, :class_name=>'Atrium::Showcase::Item::Featured', :foreign_key=>"atrium_showcase_id"
  has_many :related_items, :class_name=>'Atrium::Showcase::Item::Related', :foreign_key=>"atrium_showcase_id"
  has_many :descriptions, :class_name=>'Atrium::Showcase::Item::Description', :foreign_key=>"atrium_showcase_id"
  belongs_to :exhibit, :class_name=>'Atrium::Exhibit', :foreign_key=>"atrium_exhibit_id"
  has_many :facet_selections, :class_name=>'Atrium::Showcase::FacetSelection', :foreign_key=>"atrium_showcase_id"

  validates_presence_of :atrium_exhibit_id

  accepts_nested_attributes_for :featured_items, :allow_destroy=>true
  accepts_nested_attributes_for :related_items, :allow_destroy=>true
  accepts_nested_attributes_for :descriptions, :allow_destroy=>true
  accepts_nested_attributes_for :facet_selections

  set_table_name :atrium_showcases

  def initialize(opts={})
    super
    #facet
  end
end