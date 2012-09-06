require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe Atrium::Exhibit do

  it { should belong_to :collection }

  it { should have_many :showcases }

  it { should have_many :browse_levels }

  it_behaves_like "query_param_mixin" do
    Given(:subject) { Atrium::Exhibit.new }
  end

  it_behaves_like "is_showcased_mixin" do
    Given(:subject) { FactoryGirl.create(:exhibit) }
  end

  context '#accessible attributes' do
    it "should not allow access to exhibit fields" do
      expect do
        Atrium::Exhibit.new(set_number: 1, label:"test", filter_query_params:"this is filter query params")
      end.should_not raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  context '#checking attributes' do
    Given(:exhibit) { subject }
    Given(:set_number) { 1234 }
    When { exhibit.set_number = set_number }
    When { exhibit.label = label }
    context 'pretty_title default' do
      Given(:label) { '' }
      Then { exhibit.pretty_title.should == "Exhibit #{set_number}" }
    end

    context 'pretty_title overwritten' do
      Given(:label) { 'Hello World'}
      Then { exhibit.pretty_title.should == label }
    end
  end


  context 'with database' do
    before(:each) do
      @collection = Atrium::Collection.new
      @collection.save
      @exhibit = Atrium::Exhibit.new(atrium_collection_id:@collection.id,set_number:1)
      @exhibit.save
    end

    after(:each) do
      @exhibit.delete
      @collection.delete
    end

    describe "browse_facet_names" do
      it "should return an array of browse facet names" do
        @exhibit.browse_levels.create({solr_facet_name:"my_facet_1",label:"My Category",level_number:1})
        @exhibit.browse_levels.create({solr_facet_name:"my_facet_2",label:"",level_number:2})
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
        @exhibit.browse_levels.create({solr_facet_name:"my_facet_1",label:"My Category",level_number:1})
        @exhibit.browse_levels.create({solr_facet_name:"my_facet_2",label:"",level_number:2})
        (@exhibit.browse_levels.collect {|x| x.solr_facet_name}).should == ["my_facet_1","my_facet_2"]
      end

      it "should return browse levels sorted by level number" do
        @exhibit.browse_levels.create({solr_facet_name:"my_facet_1",label:"My Category",level_number:2})
        @exhibit.browse_levels.create({solr_facet_name:"my_facet_2",label:"",level_number:1})
        (@exhibit.browse_levels.collect {|x| x.solr_facet_name}).should == ["my_facet_2","my_facet_1"]
      end
    end
  end

end
