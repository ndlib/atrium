class CreateAtriumShowcases < ActiveRecord::Migration
  def self.up
    create_table :atrium_showcases do |t|
      t.text :showcase_items
      t.references :showcases,  :polymorphic=>true
      t.string :tag
      t.integer :sequence
      t.timestamps
    end
  end

  def self.down
    drop_table :atrium_showcases
  end
end
