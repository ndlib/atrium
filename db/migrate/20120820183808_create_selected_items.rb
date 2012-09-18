class CreateSelectedItems < ActiveRecord::Migration
  def self.up
    create_table :selected_items do |t|
      t.integer :user_id, :null=>false
      t.text :url
      t.string :document_id
      t.string :title
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :selected_items
  end
end
