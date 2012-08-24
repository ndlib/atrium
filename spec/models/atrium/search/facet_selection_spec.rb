require 'spec_helper'

describe Atrium::Search::FacetSelection  do
  subject { Atrium::Search::FacetSelection.new({:field_name=>field_name})}
  describe "#lable without without Dependency Injection replacement" do
    let(:field_name) { 'pub_date' }
    it 'should retrieve when found' do
      subject.label.should == 'Publication Year'
    end
  end
end