require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::Exhibit do
  subject { Atrium::Exhibit.new }

  it { should be_accessible :label }

  it { should belong_to :collection }

  it { should have_many :showcases }

  describe 'browse_levels' do
    it { should have_many :browse_levels }

    it 'should have browse_facet_names' do
      subject.expects(:browse_levels)
    end
  end

  before(:each) do
    @collection = Atrium::Collection.new
    @collection.save
    @exhibit = Atrium::Exhibit.new(:atrium_collection_id=>@collection.id,:set_number=>1)
    @exhibit.save
  end

  after(:each) do
    @exhibit.delete
    @collection.delete
  end

  describe "browse_facet_names" do
    it "should return an array of browse facet names" do
      @exhibit.browse_levels.create({:solr_facet_name=>"my_facet_1",:label=>"My Category",:level_number=>1})
      @exhibit.browse_levels.create({:solr_facet_name=>"my_facet_2",:label=>"",:level_number=>2})
      @exhibit.browse_facet_names.size.should == 2
      @exhibit.browse_facet_names.include?("my_facet_1").should == true
      @exhibit.browse_facet_names.include?("my_facet_2").should == true
    end

    it "should remove associated showcases if a browse facet removed" do
      pending "need to test that associated showcases are removed if a browse facet is removed..."
    end

    it "if no browse facets defined it should return an empty array" do
      @exhibit.browse_facet_names.should == []
    end
  end

  describe "browse_levels" do
    it "should return array of levels used in browsing" do
      @exhibit.browse_levels.create({:solr_facet_name=>"my_facet_1",:label=>"My Category",:level_number=>1})
      @exhibit.browse_levels.create({:solr_facet_name=>"my_facet_2",:label=>"",:level_number=>2})
      (@exhibit.browse_levels.collect {|x| x.solr_facet_name}).should == ["my_facet_1","my_facet_2"]
    end

    it "should return browse levels sorted by level number" do
      @exhibit.browse_levels.create({:solr_facet_name=>"my_facet_1",:label=>"My Category",:level_number=>2})
      @exhibit.browse_levels.create({:solr_facet_name=>"my_facet_2",:label=>"",:level_number=>1})
      (@exhibit.browse_levels.collect {|x| x.solr_facet_name}).should == ["my_facet_2","my_facet_1"]
    end
  end
end
