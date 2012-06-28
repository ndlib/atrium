class Atrium::Collection < ActiveRecord::Base
  self.table_name = 'atrium_collections'

  has_many :exhibits,      :class_name => 'Atrium::Exhibit',       :foreign_key => 'atrium_collection_id', :order => 'set_number ASC', :dependent => :destroy
  has_many :search_facets, :class_name => 'Atrium::Search::Facet', :foreign_key => 'atrium_collection_id', :dependent => :destroy
  has_many :showcases,     :class_name => 'Atrium::Showcase',      :as => :showcases

  serialize :filter_query_params
  serialize :collection_items, Hash

  attr_accessible :collection_items, :filter_query_params, :theme, :title, :title_markup, :collection_description, :search_instructions, :search_facet_names,:url_slug, :exhibits_attributes, :search_facets_attributes

  accepts_nested_attributes_for :exhibits,      :allow_destroy => true
  accepts_nested_attributes_for :search_facets, :allow_destroy => true
  #attr_accessible :exhibits_attributes, :search_facets_attributes
  #attr_accessible :exhibits_attributes, :search_facets_attributes

  @@included_themes = ['default']

  def self.available_themes
    return @@available_themes if defined? @@available_themes
    # NOTE: theme filenames should conform to rails expectations and only use periods to delimit file extensions
    local_themes = Dir.entries(File.join(Rails.root, 'app/views/layouts/atrium_themes')).reject {|f| f =~ /^\./}
    local_themes.collect!{|f| f.split('.').first}
    @@available_themes = @@included_themes + local_themes
  end

  def collection_items
    read_attribute(:collection_items) || write_attribute(:collection_items, {})
  end

  def solr_doc_ids
    collection_items[:solr_doc_ids] unless collection_items.blank?
  end

  def search_facet_names
    search_facets.map{|facet| facet.name }
  end

  def pretty_title
    title.blank? ? 'Unnamed Collection' : title
  end

  def has_custom_title?
    !title_markup.blank?
  end

  def display_title
    has_custom_title? ? title_markup.html_safe : "<h2>#{title}</h2>".html_safe
  end

  def search_facet_names=(collection_of_facet_names)
    existing_facet_names = search_facets.map{|facet| facet.name }
    add_collection_of_facets_by_name( collection_of_facet_names - existing_facet_names )
    remove_collection_of_facets_by_name( existing_facet_names - collection_of_facet_names )
  end

  def exhibit_order
    exhibit_order = {}
    exhibits.map{|exhibit| exhibit_order[exhibit.id] = exhibit.set_number }
    exhibit_order
  end

  def exhibit_order=(exhibit_order = {})
    valid_ids = exhibits.select(:id).map{|exhibit| exhibit.id}
    exhibit_order.each_pair do |id, order|
      Atrium::Exhibit.find(id).update_attributes!(:set_number => order) if valid_ids.include?(id.to_i)
    end
  end

  def theme_path
    theme.blank? ? 'atrium_themes/default' : "atrium_themes/#{theme}"
  end

  private

  def add_collection_of_facets_by_name(collection_of_facet_names)
    collection_of_facet_names.each do |name|
      search_facets << Atrium::Search::Facet.find_or_create_by_name_and_collection_id(name, id)
    end
  end

  def remove_collection_of_facets_by_name(collection_of_facet_names)
    collection_of_facet_names.each do |name|
      search_facets.delete(Atrium::Search::Facet.find_by_name_and_collection_id(name, id))
    end
  end

end
