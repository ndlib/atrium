class Atrium::ExhibitsController < Atrium::BaseController

  before_filter :initialize_collection, :except=>[:index, :create]

  def new
    @exhibit = Atrium::Exhibit.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @exhibit = Atrium::Exhibit.new(params[:atrium_exhibit])
    if @exhibit.update_attributes(params[:atrium_exhibit])
      flash[:notice] = 'Exhibit was successfully created.'
      redirect_to :controller=>"atrium/collections", :action => "edit", :id=>@exhibit.atrium_collection_id
    end
  end

  def edit
    @exhibit = Atrium::Exhibit.find(params[:id])
    @atrium_collection = @exhibit.collection
    @exhibit_navigation_data = get_exhibit_navigation_data
  end

  def update
    @exhibit = Atrium::Exhibit.find(params[:id])
    if @exhibit.update_attributes(params[:atrium_exhibit])
      flash[:notice] = 'Exhibit was successfully updated.'
    end
    redirect_to :action => "edit"
  end

  def show
    #get children of emission dates
    @members = get_all_children(@browse_document_list, "is_member_of_s")
    @exhibit= Atrium::Exhibit.find(params[:id])
    @exhibit_navigation_data = get_exhibit_navigation_data
    if @exhibit && @exhibit.filter_query_params && @exhibit.filter_query_params[:solr_doc_ids]

      items_document_ids = @exhibit.filter_query_params[:solr_doc_ids].split(',')

      @collection_items_response, @collection_items_documents = get_solr_response_for_field_values("id",items_document_ids || [])
    end


    @atrium_showcase=Atrium::Showcase.with_selected_facets(@exhibit.id, @exhibit.class.name, params[:f]).first
    if @atrium_showcase && !@atrium_showcase.showcase_items[:solr_doc_ids].nil?

      selected_document_ids = @atrium_showcase.showcase_items[:solr_doc_ids].split(',')

      @response, @featured_documents = get_solr_response_for_field_values("id",selected_document_ids || [])
    end
    @description_hash=get_description_for_showcase(@atrium_showcase) unless @atrium_showcase.nil?
    if params[:no_layout]
      render :layout=>false
    end
  end

  def set_exhibit_scope
    logger.error("into scoping")
    session[:copy_folder_document_ids] = session[:folder_document_ids]
    session[:folder_document_ids] = []
    @exhibit = Atrium::Exhibit.find(params[:id])

    session[:folder_document_ids] = @exhibit.filter_query_params[:solr_doc_ids].split(',') if @exhibit.filter_query_params && @exhibit.filter_query_params[:solr_doc_ids]
    p = params.dup
    p.delete :action
    p.delete :id
    p.delete :controller
    #make sure to pass in a search_fields parameter so that it shows search results immediately
    redirect_to catalog_index_path(p)
  end

  def unset_exhibit_scope
     @exhibit = Atrium::Exhibit.find(params[:id])
     @exhibit.update_attributes(:filter_query_params=>nil)
     flash[:notice] = 'Exhibit scope removed successfully'
     render :action => "edit"
  end

  def destroy
    @exhibit = Atrium::Exhibit.find(params[:id])
    Atrium::Exhibit.destroy(params[:id])
    flash[:notice] = 'Exhibit '+params[:id] +' was deleted successfully.'
    redirect_to edit_atrium_collection_path(@exhibit.atrium_collection_id)
  end

  def initialize_collection
    if collection_id = determine_collection_id
      return __initialize_collection( collection_id )
    else
      return false
    end
  end


private

def determine_collection_id
  if params[:id]
    exhibit = Atrium::Exhibit.find(params[:id])
    collection_id = exhibit.atrium_collection_id if exhibit
  end
  return collection_id
end

end
