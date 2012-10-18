module ApplicationHelper
  include Atrium::ApplicationHelper
  include Atrium::CollectionsHelper
  include Atrium::ShowcasesHelper
  include Atrium::MarkdownHelper
  include NavigationHelper
  include SolrHelper

  def in_unscoped_catalog_search?
    (params[:controller] == "catalog") && !params[:id]
  end

  def in_collection_context?
    !defined?(@collection).nil?
  end

  def breadcrumb_links
    in_collection_context? ? breadcrumb_builder : "Search Across Collections"
  end

  # TODO: Improve the robustness of this implementation
  def breadcrumb_builder
    @collection.pretty_title
  end

  def if_browsing_facet?
    params[:f] && current_user
  end

  def application_name
    "Digitial Collections &mdash; Rare Books &amp; Special Collections".html_safe
  end

  def collection_title
    if @collection
      if @collection.title_markup.blank?
        "<h1 id=\"collection-title\">#{@collection.title}</h1>".html_safe
      else
        "<div id=\"collection-title\">#{@collection.title_markup}\n</div>".html_safe
      end
    end
  end
end
