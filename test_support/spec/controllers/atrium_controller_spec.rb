require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class AtriumControllerTest < ActionController::Base
end

describe AtriumControllerTest do

  after :all do
    Object.send(:remove_const, :AtriumControllerTest)
  end

  it "should add the necessary helpers to classes that include it" do
    AtriumControllerTest.send(:include, CatalogHelper)
    AtriumControllerTest.send(:include, BlacklightHelper)
    AtriumControllerTest.send(:include, Blacklight::SolrHelper)
    AtriumControllerTest.send(:include, Atrium::AtriumHelperBehavior)
    AtriumControllerTest.send(:include, Atrium::SolrHelper)
    AtriumControllerTest.send(:include, Atrium::LayoutHelper)
    AtriumControllerTest.send(:include, Atrium::CollectionsHelper)
    AtriumControllerTest.send(:include, Atrium::DescriptionsHelper)
    AtriumControllerTest.expects(:layout).with(:current_layout)
    AtriumController.solr_search_params_logic.should include(:add_exclude_fq_to_solr)
  end

end