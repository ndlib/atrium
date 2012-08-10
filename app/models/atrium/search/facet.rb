module Atrium
  class Search::Facet < ActiveRecord::Base
    self.table_name = 'atrium_search_facets'

    belongs_to(
      :collection,
      :class_name => 'Atrium::Collection',
      :foreign_key => 'atrium_collection_id'
    )

    validates_presence_of(
      :atrium_collection_id,
      :name
    )

    attr_accessible(
      :atrium_collection_id,
      :name
    )
  end
end
