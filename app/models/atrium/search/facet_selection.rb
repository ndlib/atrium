module Atrium
  class Search::FacetSelection
    include Atrium::ApplicationHelper

    attr_reader :field_name

    def initialize(field_name_hash)
      @field_name = field_name_hash[:field_name]
    end

    def label
      @label ||= Atrium.config.label_for_facet(field_name)
    end
  end
end
