# This migration comes from atrium (originally 20120731134904)
class CreateAtriumDescriptions < ActiveRecord::Migration
  def self.up
    create_table :atrium_descriptions do |t|
      t.integer :atrium_showcase_id, :null=>false
      t.string :page_display
      t.string :title
      t.string :description_solr_id
      t.timestamps
    end
    add_index :atrium_descriptions, :id
    add_index :atrium_descriptions, :atrium_showcase_id
  end

  def self.down
    drop_table :atrium_descriptions
  end

end
