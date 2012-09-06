module Atrium
  class Showcase::FacetSelection < ActiveRecord::Base
    belongs_to(
        :showcase,
        class_name: 'Atrium::Showcase',
        foreign_key: 'atrium_showcase_id'
    )

    validates_presence_of(
        :atrium_showcase_id,
        :value,
        :solr_facet_name
    )

    attr_accessible(
        :atrium_showcase_id,
        :solr_facet_name,
        :value
    )
  end
end
