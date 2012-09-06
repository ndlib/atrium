require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Atrium::Showcase::FeaturedSelection do

  describe "retrieve solr id and title from hash" do
    subject { Atrium::Showcase::FeaturedSelection.new({id:field_name, title:title})}
    let(:field_name) { 'solr_doc_id' }
    let(:title) { 'solr_doc_title' }
    it 'should retrieve solr id from hash' do
      subject.solr_id.should == 'solr_doc_id'
    end

    it 'should retrieve title from hash' do
      subject.title.should == 'solr_doc_title'
    end
  end
end

