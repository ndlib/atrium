require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::BrowseLevel do
  Given (:browse_level) { Atrium::BrowseLevel.new }

  it { should belong_to :exhibit }

  it { should be_accessible :filter_query_params }

  it { should be_accessible :label }

  it { should be_accessible :level_number }
  it { should validate_presence_of :level_number }

  it { should be_accessible :solr_facet_name }
  it { should validate_presence_of :solr_facet_name }

  it { should respond_to :selected }
  it { should respond_to :selected= }

  context '#values' do
    Then { browse_level.values.should be_kind_of Enumerable }
  end

  describe '#to_s' do
    Given(:comparison_string) { 'Hello'}
    When { browse_level.solr_facet_name = comparison_string }
    Then { browse_level.to_s.should == comparison_string }
  end

end
