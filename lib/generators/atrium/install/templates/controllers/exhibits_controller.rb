# TODO: Move to generator
class ExhibitsController  < AtriumBaseController


  def show
    @exhibit_navigation_data = get_exhibit_navigation_data(@exhibit)
    @showcases=find_showcases
    logger.debug("Showcase: #{@showcase.inspect}")
  end

  def find_collection
    if params.has_key? :id
      @exhibit = Atrium::Exhibit.find(params[:id])
      @collection = @exhibit.collection
      return __initialize_collection
    else
      return false
    end
  end

  def find_showcases
    Atrium::Showcase.with_selected_facets(@exhibit.id, @exhibit.class.name, params[:f])
  end

  def evaluate_query_params
    unless @exhibit
      raise("No exhibit object found. Please initialize exhibit")
    end
    assets_to_extract_query = []
    assets_to_extract_query << @exhibit
    assets_to_extract_query << @exhibit.collection

    if @exhibit.respond_to?(:browse_levels)
      assets_to_extract_query << @exhibit.browse_levels
    end

    @extra_controller_params = prepare_extra_controller_params_for_asset_query(
      assets_to_extract_query,
      params
    )
  end

  def determine_layout
    @exhibit.collection.theme_path
  end

end