class CreateAtriumBrowseLevels < ActiveRecord::Migration
  def self.up
    create_table :atrium_browse_levels do |t|
      t.integer :atrium_exhibit_id, :null=>false
      t.integer :level_number, :null=>false
      t.string :filter_query_params
      t.string :solr_facet_name
      t.string :label
      t.string :exclude_query_params
      t.timestamps
    end
    add_index :atrium_browse_levels, :atrium_exhibit_id
  end

  def self.down
    drop_table :atrium_browse_levels
  end
end
