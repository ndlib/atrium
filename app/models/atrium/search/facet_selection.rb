require 'morphine'
class Atrium::Search::FacetSelection
  attr_reader :field_name

  def initialize(field_name)
    @field_name = field_name
  end

  def label
    @label ||= facet_configuration[:label]
  end

  include Morphine
  register :facet_configuration do
    CatalogController.blacklight_config.facet_fields[field_name] || {}
  end
end
