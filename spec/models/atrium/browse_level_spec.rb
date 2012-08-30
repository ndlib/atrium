require 'spec_helper'

describe Atrium::BrowseLevel do
  subject { Atrium::BrowseLevel.new }

  it_behaves_like "query_param_mixin"

  it { should belong_to :exhibit }

  it { should be_accessible :label }

  it { should be_accessible :level_number }

  it { should validate_presence_of :atrium_exhibit_id }

  it { should be_accessible :solr_facet_name }
  it { should validate_presence_of :solr_facet_name }

  it { should respond_to :selected }
  it { should respond_to :selected= }

  context '#values' do
    Then { subject.values.should be_kind_of Enumerable }
  end

  describe '#to_s' do
    Given(:comparison_string) { 'Hello'}
    When { subject.solr_facet_name = comparison_string }
    Then { subject.to_s.should == comparison_string }
  end

end

