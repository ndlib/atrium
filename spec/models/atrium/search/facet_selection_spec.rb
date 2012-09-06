require 'spec_helper'

describe Atrium::Search::FacetSelection  do
  subject { Atrium::Search::FacetSelection.new({ field_name: field_name })}
  describe "should get facet lable from Atrium configuration" do
    before do
      facet_configuration = {
        facet: {
          field_names: ['pub_date'],
          labels: {'pub_date' => 'Publication Year'}
        }
      }
      Atrium.stub!(:config).and_return(facet_configuration)
    end
    let(:field_name) { 'pub_date' }
    context 'should retrieve when found' do
      Then { subject.label.should == 'Publication Year'}
    end
  end
end
