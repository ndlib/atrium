module Atrium
  class Search::FacetSelection
    include Atrium::ApplicationHelper

    attr_reader :field_name

    def initialize(field_name_hash)
      @field_name = field_name_hash[:field_name]
    end

    def label
      @label ||= atrium_facet_field_labels[field_name]
    end
  end
end
