# TODO: Move to generator
class DescriptionsController  < ApplicationController
  before_filter :find_collection
  layout :determine_layout
  include ApplicationHelper
  include Blacklight::SolrHelper
  include CollectionsHelper

  def show

  end

  protected
  def find_collection
    find_description
    @collection = @showcase.collection
  end

  def find_description
    @description=Atrium::Description.find(params[:id])
    @showcase= @description.showcase
  end

  def evaluate_query_params
    unless @collection
      raise("No collection object found. Please initialize collection")
    end
    @extra_controller_params =
    prepare_extra_controller_params_for_asset_query(@collection,params)
  end

  def determine_layout
    @collection.theme_path
  end
end

