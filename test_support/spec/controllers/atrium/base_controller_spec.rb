require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::BaseController do

  it "should add the necessary helpers to classes that include it" do
    Atrium::BaseController.solr_search_params_logic.should include(:add_exclude_fq_to_solr)
  end

  it 'should delegate blacklight_config to CatalogController' do
    # CatalogController.expects(:blacklight_config).returns(:returning_value)
    Atrium::BaseController.new.send(:blacklight_config).should == CatalogController.blacklight_config
  end
end