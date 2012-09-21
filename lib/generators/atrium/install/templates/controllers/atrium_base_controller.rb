# TODO: Move to
class AtriumBaseController < ApplicationController

  before_filter :find_collection
  include ApplicationHelper
  include CollectionsHelper
  include CatalogHelper
  include BlacklightHelper
  include Blacklight::SolrHelper
  include SolrHelper

  layout :determine_layout

  helper_method :get_solr_response_for_field_values

  self.solr_search_params_logic += [:add_exclude_fq_to_solr]

end
