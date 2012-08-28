module Atrium
  module ApplicationHelper

    def application_name
      Atrium.config[:application_name].html_safe rescue nil
    end

    def atrium_facet_field_names
      Atrium.config[:facet][:field_names]
    end

    def atrium_facet_field_labels
      Atrium.config[:facet][:labels]
    end

  end
end
