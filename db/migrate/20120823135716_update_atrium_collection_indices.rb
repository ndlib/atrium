class UpdateAtriumCollectionIndices < ActiveRecord::Migration
  def up
    remove_index :atrium_collections, :url_slug
    add_index :atrium_collections, :url_slug, unique: true
    add_index :atrium_collections, :title, unique: true
  end

  def down
    remove_index :atrium_collections, :title, unique: true
    remove_index :atrium_collections, :url_slug
    add_index :atrium_collections, :url_slug
  end
end
