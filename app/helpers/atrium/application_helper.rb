module Atrium
  module ApplicationHelper

    def application_name
      'Atrium Application'
    end

    def atrium_facet_field_names
      Atrium.config[:facet][:field_names]
    end

    def atrium_facet_field_labels
      Atrium.config[:facet][:labels]
    end

  end
end
