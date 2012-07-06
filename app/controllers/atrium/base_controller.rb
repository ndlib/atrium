require 'atrium/layout_helper'
require 'atrium/atrium_helper_behavior'

class Atrium::BaseController < ApplicationController

  include CatalogHelper
  include BlacklightHelper
  include Blacklight::SolrHelper
  include Atrium::AtriumHelperBehavior
  include Atrium::SolrHelper
  include Atrium::LayoutHelper
  include Atrium::CollectionsHelper
  include Atrium::DescriptionsHelper

  layout :current_layout

  self.solr_search_params_logic += [:add_exclude_fq_to_solr]

end
