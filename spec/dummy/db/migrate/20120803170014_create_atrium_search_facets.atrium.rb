# This migration comes from atrium (originally 20120731135721)
class CreateAtriumSearchFacets < ActiveRecord::Migration
  def self.up
    create_table :atrium_search_facets do |t|
      t.integer :atrium_collection_id, :null=>false
      t.string :name
      t.timestamps
    end
    add_index :atrium_search_facets, :id
    add_index :atrium_search_facets, :atrium_collection_id
  end

  def self.down
    drop_table :atrium_search_facets
  end
end
