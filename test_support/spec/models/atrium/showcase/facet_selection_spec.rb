require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Atrium::Showcase::FacetSelection  do

  it { should belong_to :showcase }

  it { should validate_presence_of :value }
  it { should be_accessible :value }

  it { should validate_presence_of :atrium_showcase_id }

  it { should validate_presence_of :solr_facet_name }
  it { should be_accessible :solr_facet_name }

end
