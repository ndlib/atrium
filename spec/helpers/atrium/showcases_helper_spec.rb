require 'spec_helper'
describe Atrium::ShowcasesHelper do

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
    Given(:showcase) { mock_model(Atrium::Showcase) }
    Given(:facet_name) { 'My Facet Name' }
    Given(:facet_value) { 'My Facet Value' }
    Given(:facet_selections) { Atrium::Showcase::FacetSelection.new({ solr_facet_name: facet_name, value:facet_value })}
    Given(:configured_expected_label) { 'Hello World'}
    Given(:config) {
      double_config = double('Config')
      double_config.should_receive(:label_for_facet).
          with(facet_name).and_return(configured_expected_label)
      double_config
    }
    it "should return facet names" do
      showcase.stub!(:facet_selections).and_return([facet_selections])
      Atrium.should_receive(:config).and_return(config)
      result = helper.render_showcase_facet_selection(showcase)
      result.should == "{\"#{configured_expected_label}\"=>\"#{facet_value}\"}"
    end
  end

end
