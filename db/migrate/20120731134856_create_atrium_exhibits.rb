class CreateAtriumExhibits < ActiveRecord::Migration
  def self.up
    create_table :atrium_exhibits do |t|
      t.integer :atrium_collection_id, :null=>false
      t.integer :set_number, :null=>false
      t.string :label
      t.string :filter_query_params
      t.string :exclude_query_params
      t.timestamps
    end
    add_index :atrium_exhibits, :atrium_collection_id
  end

  def self.down
    drop_table :atrium_exhibits
  end
end
