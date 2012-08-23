class AddLookupIndicesAsRequired < ActiveRecord::Migration
  def change
    add_index :atrium_showcases, [:showcases_type, :showcases_id]
    add_index :atrium_descriptions, :description_solr_id
    add_index :atrium_descriptions,
      [:atrium_showcase_id,:description_solr_id],
      name: 'index_atrium_descriptions_showcase_and_solr_id'
    add_index :atrium_essays, :content_type
    add_index :atrium_essays, [:atrium_description_id, :content_type]
  end
end
