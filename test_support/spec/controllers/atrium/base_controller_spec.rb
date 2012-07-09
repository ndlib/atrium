require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::BaseController do

  it "should add the necessary helpers to classes that include it" do
    Atrium::BaseController.solr_search_params_logic.should include(:add_exclude_fq_to_solr)
  end

end