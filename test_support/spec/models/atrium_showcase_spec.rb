require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Atrium::Showcase do
  before(:each) do
    @collection = Atrium::Collection.new
    @collection.save
    @showcase = Atrium::Showcase.new(:atrium_collection_id=>@collection.id,:set_number=>1)
    @showcase.save
  end

  after(:each) do
    @showcase.delete
    @collection.delete
  end

  describe "#label" do
    it "should return the browse set label" do
      @showcase.update_attributes({:label=>"My label"})
      @showcase.label.should == "My label"
    end
  end

  describe "browse_facet_names" do
    it "should return an array of browse facet names" do
      @showcase.browse_levels.create({:solr_facet_name=>"my_facet_1",:label=>"My Category",:level_number=>1})
      @showcase.browse_levels.create({:solr_facet_name=>"my_facet_2",:label=>"",:level_number=>2})
      @showcase.browse_facet_names.size.should == 2
      @showcase.browse_facet_names.include?("my_facet_1").should == true
      @showcase.browse_facet_names.include?("my_facet_2").should == true
    end

    it "should remove associated browse_pages if a browse facet removed" do
      pending "need to test that associated browse_pages are removed if a browse facet is removed..."
    end

    it "if no browse facets defined it should return an empty array" do 
      @showcase.browse_facet_names.should == []
    end
  end

  describe "browse_levels" do
    it "should return array of levels used in browsing" do
      @showcase.browse_levels.create({:solr_facet_name=>"my_facet_1",:label=>"My Category",:level_number=>1})
      @showcase.browse_levels.create({:solr_facet_name=>"my_facet_2",:label=>"",:level_number=>2})
      (@showcase.browse_levels.collect {|x| x.solr_facet_name}).should == ["my_facet_1","my_facet_2"]
    end

    it "should return browse levels sorted by level number" do
      @showcase.browse_levels.create({:solr_facet_name=>"my_facet_1",:label=>"My Category",:level_number=>2})
      @showcase.browse_levels.create({:solr_facet_name=>"my_facet_2",:label=>"",:level_number=>1})
      (@showcase.browse_levels.collect {|x| x.solr_facet_name}).should == ["my_facet_2","my_facet_1"]
    end
  end
  
  describe "browse_pages" do
    it "should return array of browse_pages defined" do
      @browse_page = @showcase.browse_pages.create
      @browse_page2 = @showcase.browse_pages.create
      @showcase.browse_pages.size.should == 2
      @showcase.browse_pages.include?(@browse_page).should == true
      @showcase.browse_pages.include?(@browse_page2).should == true
    end
  end
end
