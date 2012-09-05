require 'spec_helper'
describe Atrium::ShowcasesHelper do
  context "#get parent show path " do
    pending
  end
  describe "test showcase parent path" do
    let(:collection) { Atrium::Collection.new }
    let(:collection_showcase) {Atrium::Showcase.new(:showcases_id=>collection.id, :showcases_type=>collection.class.name)}
    let(:exhibit) {Atrium::Exhibit.new(:atrium_collection_id=>collection.id,:set_number=>1)}
    let(:exhibit_showcase) {Atrium::Showcase.new(:showcases_id=>exhibit.id, :showcases_type=>exhibit.class.name)}

    before(:each) do
      exhibit_showcase.stub!(:id).and_return(1)
      exhibit_showcase.stub!(:parent).and_return(exhibit)
      exhibit.stub!(:id).and_return(1)
      collection_showcase.stub!(:id).and_return(1)
      collection_showcase.stub!(:parent).and_return(collection)
      collection.stub!(:id).and_return(1)
    end

    context "#get parent edit path " do
      describe 'showcase parent edit path' do
        it "should return exhibit as parent" do
          helper.get_showcase_parent_edit_path(exhibit_showcase).should == edit_exhibit_showcase_path(:id=>exhibit_showcase.id, :exhibit_id=>exhibit.id)
        end
        it "should return collection show path" do
          helper.get_showcase_parent_edit_path(collection_showcase).should == edit_collection_showcase_path(:id=>collection_showcase.id, :collection_id=>collection.id)
        end
      end
    end

    context "#get parent show path " do
      describe 'showcase parent edit path' do
        it "should return exhibit as parent" do
          helper.get_showcase_parent_show_path(exhibit_showcase).should == exhibit_showcase_path(:id=>exhibit_showcase.id, :exhibit_id=>exhibit.id)
        end
        it "should return collection show path" do
          helper.get_showcase_parent_show_path(collection_showcase).should == collection_showcase_path(:id=>collection_showcase.id, :collection_id=>collection.id)
        end
      end
    end
  end
  context "#render_showcase_facet_selection " do
    let(:showcase) { mock_model(Atrium::Showcase) }
    let(:facet_selections) { Atrium::Showcase::FacetSelection.new({ :solr_facet_name => "test_facet", :value=>"book" })}
    let(:facet_configuration) {
          {:facet => {
              :field_names => ['test_facet'],
              :labels => {'test_facet' => 'Format'}
          }  }
      }
    it "should return facet names" do
      showcase.stub!(:facet_selections).and_return([facet_selections])
      Atrium.stub!(:config).and_return(facet_configuration)
      result = helper.render_showcase_facet_selection(showcase)
      result.should == "{\"Format\"=>\"book\"}"
    end
  end

end
