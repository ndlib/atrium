require 'atrium/layout_helper'

class AtriumController < ApplicationController

  include CatalogHelper
  include BlacklightHelper
  include Blacklight::SolrHelper
  include AtriumHelper
  include Atrium::SolrHelper
  include Atrium::LayoutHelper
  include Atrium::CollectionsHelper
  include Atrium::DescriptionsHelper

  layout :current_layout

  AtriumController.solr_search_params_logic += [:add_exclude_fq_to_solr]

end
