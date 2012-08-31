require_relative '../spec_helper'

describe BrowseLevelEvaluationService do
  Given(:solr_search_params_callable) { lambda{|arg1|} }
  Given(:facet) { Object.new.tap {|o| def o.name; 'something'; end } }
  Given(:facets) {
    Object.new.tap {|o| def o.facets; []; end }
  }
  Given(:get_search_results_callable) {
    lambda {|arg1,arg2| facets }
  }
  Given(:facet_in_params_callable) { lambda{|arg1,arg2|} }
  Given(:browse_level_1) { Atrium::BrowseLevel.new }
  Given(:browse_level_2) { Atrium::BrowseLevel.new }
  Given(:collection) { Atrium::Collection.new }
  Given(:browse_levels) { [browse_level_1,browse_level_2]}
  Given(:exhibit) { Atrium::Exhibit.new }
  Given(:params) { {f: 'hello'} }
  Given(:extractor) {
    BrowseLevelEvaluationService.new(
      solr_search_params_callable,
      get_search_results_callable,
      facet_in_params_callable,
      collection,
      exhibit,
      params
    )
  }

  Then('placebo test in that it tests implementation not behavior') {
    extractor.extract(browse_levels).should == [browse_level_1]
  }
end
