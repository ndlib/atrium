class CreateAtriumCollections < ActiveRecord::Migration
  def self.up
    create_table :atrium_collections do |t|
      t.string :title
      t.string :url_slug
      t.string :filter_query_params
      t.string :theme
      t.text :title_markup
      t.text :collection_description
      t.text :search_instructions
      t.text :collection_items
      t.timestamps
    end
    add_index :atrium_collections, :url_slug
  end

  def self.down
    drop_table :atrium_collections
  end
end
