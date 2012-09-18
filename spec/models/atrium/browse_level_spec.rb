require 'spec_helper'

describe Atrium::BrowseLevel do
  Given(:facet_name) { 'My Facet Name' }
  subject { Atrium::BrowseLevel.new(solr_facet_name: facet_name) }

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

  describe '#label' do
    Given(:expected_label) { 'Hello World'}
    context 'override' do
      When{ subject.label = expected_label }
      Then{ subject.label.should == expected_label }
    end
    context 'lookup from configuration' do
      Given(:configured_expected_label) { 'Good-Bye World'}
      Given(:config) {
        double_config = double('Config')
        double_config.should_receive(:label_for_facet).
        with(facet_name).and_return(configured_expected_label)
        double_config
      }
      When{ subject.label = nil }

      Then {
        Atrium.should_receive(:config).and_return(config)
        subject.label.should == configured_expected_label
      }
    end
  end

end
