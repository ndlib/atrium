# Purpose: To walk the browse levels until we reach the current browse level.
# While walking the browse levels, determine which FacetItems to attach at each
# level.
#
# That is to say, each browse level's "values" are lazily evaluated.
#
# There is a complicated negotation of the Exhibit, Collection, BrowseLevel, and
# query params.
#
# TODO: Should this class be implemented as a delegate of the
#   ApplicationController class. I am passing in three anonymous functions that
#   could instead be deferred to the calling context.
class BrowseLevelEvaluationService
  attr_reader(
    :exhibit,
    :extra_controller_params,
    :params,
    :solr_search_params_callable,
    :get_search_results_callable
  )

  def initialize(
      solr_search_params_callable,
      get_search_results_callable,
      facet_in_params_callable,
      collection,
      exhibit,
      params
    )
    @solr_search_params_callable = solr_search_params_callable
    @get_search_results_callable = get_search_results_callable
    @facet_in_params_callable = facet_in_params_callable
    @collection = collection
    @exhibit = exhibit
    @params = params
  end

  def extract(browse_levels)
    recursive_extract(browse_levels,true)
  end

  protected
  def recursive_extract(browse_levels, top_level)
    return [] if browse_levels.nil? || browse_levels.empty?
    updated_browse_levels = []
    browse_level = browse_levels.first
    browse_facet_name = browse_level.solr_facet_name
    if (browse_level.label.nil? || browse_level.label.blank?)
      browse_level.label = Atrium.config[:facet][:labels][browse_facet_name]
    end
    updated_browse_levels << browse_level
    deep_cloned_params = Marshal.load(Marshal.dump(params))

    remove_f_params_for!(
      deep_cloned_params,
      browse_facet_name,
      browse_levels,
      top_level
    )

    response_without_f_param = extract_response_from(
      deep_cloned_params,
      browse_level
    )

    display_facet = response_without_f_param.facets.detect {|f|
      f.name == browse_facet_name
    }

    unless display_facet.nil?
      level_has_selected_facet = false
      browse_level_subset = browse_levels.slice(1,browse_levels.length-1)

      display_facet.items.each do |item|
        browse_level.values << item.value
        if @facet_in_params_callable.call(display_facet.name, item.value )
          level_has_selected_facet = true
          browse_level.selected = item.value
          if browse_levels.length > 1
            extracted_levels = recursive_extract(browse_level_subset, false)
            updated_browse_levels << extracted_levels
            updated_browse_levels.flatten!(1)
          end
        end
      end

      unless level_has_selected_facet
        updated_browse_levels << browse_level_subset
        updated_browse_levels.flatten!(1)
      end
    end
    updated_browse_levels
  end

  protected

  def remove_f_params_for!(fetchable, facet_name, browse_levels, top_level)
    begin
      f_hash = fetchable.fetch(:f)
    rescue NoMethodError, KeyError
      return fetchable
    end

    facet_entry =
    begin
      f_hash[facet_name] || f_hash[facet_name.to_s]
    rescue TypeError
      nil
    end

    if !top_level || facet_entry
      browse_levels.each do |browse_level|
        fetchable[:f].delete(browse_level.solr_facet_name)
      end
    else
      fetchable[:f] = {}
    end
  end


  def extract_response_from(modified_params, browse_level)
    prepared_params = CurrentFilterQueryParamsExtractionService.new(
      @solr_search_params_callable,
      [exhibit.collection, exhibit, browse_level, modified_params],
      [:filter_query_params,:exclude_query_params]
    ).filter_query_params

    (response_document, document_list) =
      @get_search_results_callable.call(params,prepared_params)

    response_document
  end

end
