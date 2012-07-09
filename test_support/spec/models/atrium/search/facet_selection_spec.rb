require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Atrium::Search::FacetSelection  do
  subject { Atrium::Search::FacetSelection.new(field_name)}
  let(:field_name) { 'frodo-baggins' }

  describe "#label" do
    it 'should retrieve from facet_configuration' do
      subject.
        expects(:facet_configuration).
        returns({
          :label => 'Publication Year'
        })
      subject.label.should == 'Publication Year'
    end
  end

  describe "#lable without without Dependency Injection replacement" do
    let(:field_name) { 'pub_date' }
    it 'should retrieve when found' do
      subject.label.should == 'Publication Year'
    end
  end
end