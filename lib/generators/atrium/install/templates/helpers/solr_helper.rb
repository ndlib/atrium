# TODO: Move to generator
module SolrHelper

  def __initialize_collection
    @collection_response, @collection_document_list =
      get_search_results(params, evaluate_query_params)

    @extra_controller_params =
    get_current_filter_query_params(
      @collection,
      @exhibit,
      get_current_browse_level(@exhibit),
    )
  end

  # Checks if a browse level has been navigated to for a exhibit
  # @param [Atrium::Exhibit] The current exhibit in view
  # @return [Atrium::BrowseLevel] It will return a browse level that is
  #   selected, otherwise it will return nil
  def get_current_browse_level(exhibit)
    return nil unless exhibit.respond_to?(:browse_levels)
    NavigationTree.new(exhibit.browse_levels, params[:f]).current_level
  end

  def get_exhibit_navigation_data(exhibit)
    browse_data=[]
    if exhibit.respond_to?(:browse_levels) && !exhibit.browse_levels.nil?
      updated_browse_levels = get_browse_level_data(exhibit)
      exhibit.browse_levels.each_index do |index|
        exhibit.browse_levels.fetch(index).values = updated_browse_levels.fetch(index).values
        exhibit.browse_levels.fetch(index).label = updated_browse_levels.fetch(index).label
        exhibit.browse_levels.fetch(index).selected = updated_browse_levels.fetch(index).selected
      end
      exhibit.browse_levels.flatten!
      browse_data << exhibit
    end

    browse_data=[] if check_for_scope(browse_data)
    @exhibit_navigation_data=browse_data
    browse_data
  end

  private

  def check_for_scope(exhibit_list)
    scoped_to_items=false
    #unless  @collection.filter_query_params.blank? && @collection.filter_query_params[:solr_doc_ids]
    #  scoped_to_items=true
    #end
    #return scoped_to_items
  end

  # This is a private method and should not be called directly.
  # get_exhibit_navigation_data calls this method to fill out the
  # browse_level_navigation_data array This method calls itself recursively as
  # it generates the current browse state data. It returns the browse levels
  # array with its browse level objects passed in updated with any values,
  # label, and selected value if one is selected.  It will fill in values for
  # the top browse level, and then will only fill in values for the second
  # browse level if something is selected, and so on for any deeper browse
  # levels.  If no label is defined for a browse level, it will fill in the
  # default label for the browse level facet.
  #
  # @param [Atrium::Collection] The current collection
  # @param [Atrium::Exhibit] the current exhibit
  # @params [Array] The current browse levels (will reduce as this method recurses)
  # @param [SolrResponse] the browse response from solr
  # @param [Hash] the extra controller params that need to be passed to solr if we query for another response if necessary to get child level data
  # @param [Boolean] true if the top level of the exhibit
  # @return [Array] An array of update BrowseLevel objects that are enhanced with current navigation data such as selected, values, and label filled in
  #   The relevant attributes of a BrowseLevel are
  #   :solr_facet_name [String] the facet used as the category for that browse level
  #   :label [String] browse level category label
  #   :values [Array] values to display for the browse level
  #   :selected [String] the selected value if one
  def get_browse_level_data(exhibit)
    BrowseLevelEvaluationService.new(
      method(:solr_search_params),
      method(:get_search_results),
      method(:facet_in_params?),
      exhibit.collection,
      exhibit,
      params
    ).extract(exhibit.browse_levels)
  end

  def get_current_filter_query_params(*args)
    CurrentFilterQueryParamsExtractionService.new(
      method(:solr_search_params),
      args,
      [:filter_query_params,:exclude_query_params]
    ).filter_query_params
  end

  def get_solr_documents_from_asset(asset)
    p = params.dup
    params.delete :f
    params.delete :q
    params.delete :page
    logger.debug("Asset is: #{asset.class}")
    if asset.is_a?(Atrium::Showcase)
      if asset && !asset.showcase_items.blank?
        selected_document_ids = asset.showcase_items
        response, documents = get_solr_response_for_field_values("id",selected_document_ids || [])
      end
    else
      if asset && asset.filter_query_params && asset.filter_query_params[:solr_doc_ids]
        document_ids = asset.filter_query_params[:solr_doc_ids].split(',')
        response, documents = get_solr_response_for_field_values("id",document_ids || [])
      end
    end
    params.merge!(:f=>p[:f])
    params.merge!(:q=>p[:q])
    params.merge!(:page=>p[:page])
    return  [response, documents]
  end

  def add_exclude_fq_to_solr(solr_parameters, user_params)
    logger.debug("Solr exclude!!!: #{solr_parameters.inspect}, #{user_params.inspect}")
    if ( user_params[:exclude])
      exclude_request_params = user_params[:exclude]
      solr_parameters[:fq] ||= []
      exclude_request_params.each_pair do |facet_field, value_list|
        value_list ||= []
        value_list = [value_list] unless value_list.respond_to? :each
        value_list.each do |value|
          exclude_facet="-(#{facet_value_to_fq_string(facet_field, value)})"
          exclude_query="-(#{facet_value_to_fq_string(facet_field, value)})"
          solr_parameters[:fq] << exclude_query
          solr_parameters[:fq] << exclude_facet
        end
      end
    end
  end



end
