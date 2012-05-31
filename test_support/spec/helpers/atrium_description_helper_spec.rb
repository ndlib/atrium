require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

Blacklight::SolrHelper.stubs(:class_inheritable_accessor)
include Blacklight::SolrHelper

describe Atrium::DescriptionsHelper do

  before(:each) do
    @collection = Atrium::Collection.new
    @collection.save
    @collection_showcase = Atrium::Showcase.new(:showcases_id=>@collection.id, :showcases_type=>@collection.class.name)
    @collection_showcase.save
    @exhibit = Atrium::Exhibit.new
    @exhibit_showcase = Atrium::Showcase.new(:showcases_id=>@exhibit.id, :showcases_type=>@exhibit.class.name)
    @exhibit_showcase.save

  end

  after(:each) do
    begin
      @collection.delete
      @collection_showcase.delete
    rescue
    end
    begin
      @exhibit.delete
      @exhibit_showcase.delete
    rescue
    end
  end

  describe "get_description_for_showcase" do
    it "return description hash from solr for any given collection" do
      helper.stubs(:showcase).returns(@collection_showcase)
      description_hash=helper.get_description_for_showcase(@collection_showcase)
      description_hash.size.should == 0
    end

    it "returns description details from solr for given showcase" do
      @description = Atrium::Description.new(:atrium_showcase_id=>@collection_showcase.id)
      @description.save!
      @description.update_attributes({:description_solr_id=>"RBSC-CURRENCY:715"})
      helper.expects(:get_solr_response_for_field_values).with("id",["RBSC-CURRENCY:715"]).returns([[:docs => ["id"=>"RBSC-CURRENCY:715", "title_t"=>["title"],"description_content_s"=>["description content"]]],["id"=>"RBSC-CURRENCY:715", "title_t"=>["title"],"description_content_s"=>["description content"]]])
      helper.get_description_for_showcase(@collection_showcase)
    end
  end
end
