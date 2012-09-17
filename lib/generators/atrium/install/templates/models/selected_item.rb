class SelectedItem < ActiveRecord::Base
  attr_accessible :id, :document_id, :title

  def document
    SolrDocument.new :id => document_id
  end
end
