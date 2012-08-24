require 'spec_helper'

describe Atrium::Search::FacetSelection  do
  subject { Atrium::Search::FacetSelection.new({:field_name=>field_name})}
  describe "#get label from facet config" do
    let(:field_name) { 'pub_date' }
    context 'should retrieve when found' do
      Given(:value) {
          {
            :facet => {
                         :field_names => ["pub_date"],
                         :labels => {"pub_date" => "Publication Year"}
                      }
          }
      }
      When { Atrium.config = value }
      Then { subject.label.should == 'Publication Year'}
    end
  end
end