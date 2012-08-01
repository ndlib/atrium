module Atrium
  class Search::Facet < ActiveRecord::Base
   self.table_name = 'atrium_search_facets'

    belongs_to(
        :collection,
        :class_name => 'Atrium::Collection',
        :foreign_key => 'atrium_collection_id'
    )

    scope :find_by_name_and_collection_id, lambda {|name, collection_id|
      where("#{self.quoted_table_name}.`name` = ? AND #{self.quoted_table_name}.`atrium_collection_id` = ?", name, collection_id)
    }

    def self.find_or_create_by_name_and_collection_id(name, collection_id)
      find_by_name_and_collection_id(name, collection_id).first ||
          self.create(:name => name, :atrium_collection_id => collection_id)
    end

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
