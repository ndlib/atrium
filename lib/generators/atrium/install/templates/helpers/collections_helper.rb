# TODO: Move to generator
module CollectionsHelper
  include Atrium::ApplicationHelper
  include Atrium::CollectionsHelper

  #This methods merge params q and fq with asset q and fq
  def prepare_extra_controller_params_for_asset_query(assets,params, *args)
    CurrentFilterQueryParamsExtractionService.new(
      method(:solr_search_params),
      [assets,ParamsAdaptorForFilter.new(params)].flatten,
      [:filter_query_params,:exclude_query_params]
    ).filter_query_params

  end
end
