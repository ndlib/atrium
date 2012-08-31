module Atrium
  class Search::Facet < ActiveRecord::Base
    self.table_name = 'atrium_search_facets'

    validates :collection, presence: true
    belongs_to(
      :collection,
      :class_name => 'Atrium::Collection',
      :foreign_key => 'atrium_collection_id',
      :inverse_of => :search_facets
    )

    validates :name, presence: true
    attr_accessible(
      :name
    )
  end
end
