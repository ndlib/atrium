require 'spec_helper'
describe Atrium::ShowcasesHelper do
  context "#get parent show path " do
    pending
  end
  describe "test showcase parent path" do
    Given(:collection) { FactoryGirl.create(:collection) }
    Given(:collection_showcase) { FactoryGirl.create(:collection_showcase, showcases: collection) }
    Given(:exhibit) {FactoryGirl.create(:exhibit, collection: collection,)}
    Given(:exhibit_showcase) { FactoryGirl.create(:exhibit_showcase, showcases: exhibit) }

    context "#get parent edit path " do
      describe 'showcase parent edit path' do
        it "should return exhibit as parent" do
          helper.get_showcase_parent_edit_path(exhibit_showcase).should ==
          edit_exhibit_showcase_path(exhibit, exhibit_showcase)
        end
        it "should return collection show path" do
          helper.get_showcase_parent_edit_path(collection_showcase).should ==
          edit_collection_showcase_path(collection, collection_showcase)
        end
      end
    end

    context "#get parent show path " do
      describe 'showcase parent edit path' do
        it "should return exhibit as parent" do
          helper.get_showcase_parent_show_path(exhibit_showcase).should ==
          exhibit_showcase_path(exhibit, exhibit_showcase)
        end
        it "should return collection show path" do
          helper.get_showcase_parent_show_path(collection_showcase).should ==
          collection_showcase_path(collection, collection_showcase)
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
