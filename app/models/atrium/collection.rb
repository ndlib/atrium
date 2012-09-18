require 'friendly_id'
# An Atrium::Collection contains a subset of the items in the complete index as
# defined by a Solr query. An explicitly declared subset of the total facets can
# be applied to these items. An Atrium::Collection description and or featured
# items form the Atrium::Collection can be displayed at the top level
# Atrium::Collection page. Collections can be themed independently of the base
# application and other collections.
class Atrium::Collection < ActiveRecord::Base
  extend FriendlyId
  friendly_id :url_slug, use: :slugged, slug_column: :url_slug

  validate(
    :title,
    presence: true,
    uniqueness: true,
    length: { maximum: 255, minimum: 3 }
  )
  validate(
    :url_slug,
    presence: true,
    uniqueness: true,
    length: { maximum: 255, minimum: 3 }
  )
  attr_accessible(
    :collection_items,
    :theme,
    :title,
    :title_markup,
    :collection_description,
    :search_instructions,
    :search_facet_names,
    :url_slug,
    :exhibits_attributes,
    :search_facets_attributes
  )

  include Atrium::IsShowcasedMixin

  has_many(
    :search_facets,
    class_name: 'Atrium::Search::Facet',
    foreign_key: 'atrium_collection_id',
    dependent: :destroy,
    inverse_of: :collection,
    autosave: true
  )

  accepts_nested_attributes_for :search_facets, allow_destroy: true

  def search_facet_names
    search_facets.pluck(:name)
  end


  def search_facet_names=(collection_of_facet_names)
    existing_facet_names = search_facet_names
    add_collection_of_facets_by_name(
      collection_of_facet_names - existing_facet_names
    )
    remove_collection_of_facets_by_name(
      existing_facet_names - collection_of_facet_names
    )
  end

  def add_collection_of_facets_by_name(collection_of_facet_names)
    collection_of_facet_names.each do |name|
      search_facets.find_or_initialize_by_name(name) if name.present?
    end
  end
  private :add_collection_of_facets_by_name

  def remove_collection_of_facets_by_name(collection_of_facet_names)
    search_facets.where("name IN (?)", collection_of_facet_names).destroy_all
  end
  private :remove_collection_of_facets_by_name


  has_many(
    :exhibits,
    class_name: 'Atrium::Exhibit',
    foreign_key: 'atrium_collection_id',
    order: 'set_number ASC',
    dependent: :destroy
  )

  accepts_nested_attributes_for :exhibits, allow_destroy: true

  def exhibit_order
    exhibit_order = {}
    exhibits.map{|exhibit| exhibit_order[exhibit[:id]] = exhibit.set_number }
    exhibit_order
  end

  def exhibit_order=(exhibit_order = {})
    valid_ids = exhibits.select(:id).map{|exhibit| exhibit[:id]}
    exhibit_order.each_pair do |id, order|
      if valid_ids.include?(id.to_i)
        Atrium::Exhibit.find(id).update_attributes!(set_number: order)
      end
    end
  end

  @@included_themes = ['Default']
  def self.available_themes
    return @@available_themes if defined? @@available_themes
    # NOTE: theme filenames should conform to rails expectations and only use
    # periods to delimit file extensions
    begin
      local_themes = Dir.entries(
        Rails.root.join('app/views/layouts/atrium/themes').to_s
      ).reject {|f| f =~ /^[\._]/}
      local_themes.collect!{|f| f.split('.').first.titleize}
      @@available_themes = @@included_themes + local_themes
    rescue Errno::ENOENT
      @@included_themes
    end
  end


  def theme_path
    theme.blank? ? 'atrium/themes/default' : "atrium/themes/#{theme.downcase}"
  end

  include Atrium::QueryParamMixin

  serialize :collection_items, Hash
  def collection_items
    read_attribute(:collection_items) || write_attribute(:collection_items, {})
  end

  def collection
    self
  end

  def solr_doc_ids
    collection_items[:solr_doc_ids] unless collection_items.blank?
  end

  def pretty_title
    title.blank? ? 'Unnamed Collection' : title
  end

  def display_title
    if has_custom_title?
      title_markup.html_safe
    else
      "<h2>#{pretty_title}</h2>".html_safe
    end
  end

  def has_custom_title?
    !title_markup.blank?
  end
  private :has_custom_title?
end
