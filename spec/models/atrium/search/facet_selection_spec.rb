require 'spec_helper'

describe Atrium::Search::FacetSelection  do
  subject { Atrium::Search::FacetSelection.new({ field_name: field_name })}
  describe "should get facet lable from Atrium configuration" do
    let(:field_name) { 'pub_date' }
    describe '#label' do
      context 'lookup from configuration' do
        Given(:configured_expected_label) { 'Hello World'}
        Given(:config) {
          double_config = double('Config')
          double_config.should_receive(:label_for_facet).
              with(field_name).and_return(configured_expected_label)
          double_config
        }
        Then {
          Atrium.should_receive(:config).and_return(config)
          subject.label.should == configured_expected_label
        }
      end
    end
  end
end
