# TODO: Move to generator
class CollectionsController  < AtriumBaseController

  def show
    @showcases=find_showcases
  end

  def browse
    @showcases=find_showcases
  end

  protected
  def find_collection
    if params.has_key? :id
      @collection = Atrium::Collection.find(params[:id])
      return __initialize_collection
    else
      return false
    end
  end

  def find_showcases
    Atrium::Showcase.with_selected_facets(@collection.id, @collection.class.name, {})
  end

  def evaluate_query_params
    unless @collection
      raise("No collection object found. Please initialize collection")
    end
    @extra_controller_params = prepare_extra_controller_params_for_asset_query(
      @collection,
      params
    )
  end

  def determine_layout
    @collection.theme_path
  end
end

