require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::BrowseLevel do

  it { should belong_to :exhibit }

  it { should be_accessible :filter_query_params }

  it { should be_accessible :label }

  it { should be_accessible :level_number }
  it { should validate_presence_of :level_number }

  it { should be_accessible :solr_facet_name }
  it { should validate_presence_of :solr_facet_name }

end
