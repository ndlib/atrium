
require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Atrium::Search::Facet  do
  it { should belong_to :collection }

  it { should validate_presence_of :atrium_collection_id }
  it { should be_accessible :atrium_collection_id }

  it { should validate_presence_of :name }
  it { should be_accessible :name }
end
