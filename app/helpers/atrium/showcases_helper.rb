module Atrium
  module ShowcasesHelper
    include Atrium::ApplicationHelper
    def get_parent_path(showcase)
      facet={}
      showcase.facet_selections.each do |x|
        facet[x.solr_facet_name]=x.value
      end
      main_app.polymorphic_path(showcase.parent, f: facet)
    end

    def get_showcase_parent_edit_path(showcase)
      atrium.polymorphic_path([showcase.parent,showcase],action: :edit)
    end

    def get_showcase_parent_show_path(showcase)
      atrium.polymorphic_path([showcase.parent,showcase])
    end

    def render_showcase_facet_selection(showcase)
      facets=showcase.facet_selections
      return "".html_safe unless facets
      content = []
      facets.each do |facet|
        content << facet_element(facet.solr_facet_name, facet.value)
      end
      return content.flatten.join("\n").html_safe
    end

    def facet_element(facet, value)
      {Atrium.config.label_for_facet(facet) => value}
    end
  end
end
