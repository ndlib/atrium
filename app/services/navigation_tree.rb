class NavigationTree
  def initialize(browse_levels, facet_query_hash)
    @browse_levels = browse_levels.clone
    @facet_query_hash = facet_query_hash
  end

  def current_level
    return nil unless @facet_query_hash.present?
    @browse_levels.reverse.detect do |browse_level|
      @facet_query_hash.has_key?(browse_level.solr_facet_name)
    end
  end
end
