module Atrium
  module ShowcasesHelper
    def get_parent_path(showcase)
      facet={}
      unless showcase.facet_selections.blank?
        showcase.facet_selections.each do  |x|
          facet[x.solr_facet_name]=x.value
        end
      end
      path=""
      path=showcase.for_exhibit? ? main_app.exhibit_path(:id=>showcase.parent.id, :f=>facet) : main_app.collection_path(showcase.parent)
      return path
    end
    
    def get_showcase_parent_edit_path(showcase)
      path=showcase.for_exhibit? ? edit_exhibit_showcase_path(:id=>showcase.id, :exhibit_id=>showcase.parent.id) : edit_collection_showcase_path(:id=>showcase.id, :collection_id=>showcase.parent.id)
      return path
    end

    def get_showcase_parent_show_path(showcase)
      path=showcase.for_exhibit? ? exhibit_showcase_path(:id=>showcase.id, :exhibit_id=>showcase.parent.id) : collection_showcase_path(:id=>showcase.id, :collection_id=>showcase.parent.id)
      return path
    end

    def render_facet_selection(showcase)
      facets=showcase.facet_selections
      return "".html_safe unless facets
      content = []
      facets.each do |facet|
        content << render_filter_element(facet.solr_facet_name, facet.value)
      end

      return content.flatten.join("\n").html_safe
    end

    def render_filter_element(facet, value)
      {atrium_facet_field_labels[facet] => value}
    end
  end
end
