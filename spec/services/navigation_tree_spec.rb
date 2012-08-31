require_relative '../spec_helper'

describe NavigationTree do
  Given(:browse_level_2) { Atrium::BrowseLevel.new(solr_facet_name: 'solr2') }
  Given(:browse_level_1) { Atrium::BrowseLevel.new(solr_facet_name: 'solr1') }
  Given(:navigation_tree) {
    NavigationTree.new([browse_level_1, browse_level_2], facet_query_hash)
  }
  context 'with hash for second param' do
    Given(:facet_query_hash) { { 'solr2' => 'hello', 'solr1' => 'world' } }
    Then { navigation_tree.current_level.should == browse_level_2 }
  end

  context 'with nil for second param' do
    Given(:facet_query_hash) { nil }
    Then { navigation_tree.current_level.should == nil }
  end
end
