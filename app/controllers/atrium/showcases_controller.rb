class Atrium::ShowcasesController < Atrium::BaseController

  before_filter :initialize_collection

  def new
    @parent=parent_object
    @atrium_showcase= Atrium::Showcase.with_selected_facets(@parent.id, @parent.class.name, params[:facet_selection]).first
    unless  @atrium_showcase
      @atrium_showcase = @parent.showcases.build({:showcases_id=>@parent.id, :showcases_type=>@parent.class.name})
      @atrium_showcase.save!
      if(params[:facet_selection])
        params[:facet_selection].collect {|key,value| facet_selection = @atrium_showcase.facet_selections.create({:solr_facet_name=>key,:value=>value.first}) }
        @atrium_showcase.save!
      end
    end
    set_edit_showcase_in_session
    redirect_to  parent_url(@atrium_showcase)
  end

  def show
    @atrium_showcase = Atrium::Showcase.find(params[:id])
    #TODO move this update to model rather in controller
    unless session[:folder_document_ids].blank?
      selected_document_ids = session[:folder_document_ids] || []
      #logger.debug("selected items: #{selected_document_ids.inspect}, session:#{session[:folder_document_ids].inspect}")
      @atrium_showcase.showcase_items=selected_document_ids
    end
    @atrium_showcase.save
    session_folder_ids= session[:copy_folder_document_ids] || []
    #logger.debug("Showcase after updating featured: #{@atrium_showcase.inspect}, folder_document_ids to set:#{session_folder_ids.inspect}")
    session[:folder_document_ids] = session_folder_ids
    session[:copy_folder_document_ids]=nil
    if @atrium_showcase && !@atrium_showcase.showcase_items[:solr_doc_ids].nil?
      @featured_response, @featured_documents = get_solr_response_for_field_values("id",@atrium_showcase.showcase_items[:solr_doc_ids].split(',') || [])
    end
    if params[:no_layout]
      render :layout=>false
    end
  end

  def remove_featured
    @atrium_showcase = Atrium::Showcase.find(params[:id])
    text=''
    if params[:solr_doc_id]  && @atrium_showcase.showcase_items && @atrium_showcase.showcase_items[:solr_doc_ids]
      @featured_items = @atrium_showcase.showcase_items[:solr_doc_ids].split(',') || []
      @featured_items.delete_if {|x| x.eql?(params[:solr_doc_id]) }
      @atrium_showcase.showcase_items=@featured_items
      @atrium_showcase.save
      text = 'Document with id '+params[:solr_doc_id] +' was remove from featured successfully.'
    end
    #logger.debug("Showcase after updating featured: #{@atrium_showcase.inspect}")

    flash[:notice] = text
    render :text => text
  end

  def featured
    session[:copy_folder_document_ids] = session[:folder_document_ids]
    session[:folder_document_ids] = []
    @atrium_showcase = Atrium::Showcase.find(params[:id])
    parent = @atrium_showcase.parent if @atrium_showcase.parent
    if parent.is_a?(Atrium::Collection)
      collection_id = parent.id
      exhibit_id=nil
    elsif parent.is_a?(Atrium::Exhibit)
      exhibit_id = parent.id
      collection_id = parent.atrium_collection_id
    else
      logger.error("Atrium showcase parent is invalid. Please check the parent")
      collection_id = params[:collection_id]
      exhibit_id = params[:exhibit_id]
    end
    session[:folder_document_ids] = @atrium_showcase.showcase_items[:solr_doc_ids].split(',') if @atrium_showcase.showcase_items && @atrium_showcase.showcase_items[:solr_doc_ids]
    #make sure to pass in a search_fields parameter so that it shows search results immediately
    redirect_to catalog_index_path(:add_featured=>true,:collection_id=>collection_id,:exhibit_id=>exhibit_id,:search_field=>"all_fields",:f=>params[:f])
  end

  def refresh_showcase
    @atrium_showcase = Atrium::Showcase.find(params[:id])
    path=@atrium_showcase.for_exhibit? ? atrium_exhibit_path(:id=>@atrium_showcase.showcases_id, :f=>params[:f]) :  atrium_collection_path(:id=>@atrium_showcase.showcases_id)
    unset_edit_showcase_in_session
    redirect_to path
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
      begin
        @showcase = Atrium::Showcase.find(params[:id])
      rescue
        raise "unable to find showcase from id"
      end
    elsif params[:showcase_id]
      begin
        @showcase = Atrium::Showcase.find(params[:showcase_id])
      rescue
        raise "unable to find showcase from id"
      end
    end
    if @showcase && @showcase.parent
      if @showcase.parent.is_a?(Atrium::Collection)
        atrium_collection = @showcase.parent
        collection_id = atrium_collection.id
      elsif @showcase.parent.is_a?(Atrium::Exhibit)
        exhibit = @showcase.parent
        collection_id = exhibit.atrium_collection_id
      elsif params[:collection_id]
        collection_id = params[:collection_id]
      end
    end
    return collection_id
  end

  def parent_object
    case
      when params[:exhibit_id] then parent= Atrium::Exhibit.find_by_id(params[:exhibit_id])
      when params[:collection_id] then parent = Atrium::Collection.find_by_id(params[:collection_id])
    end

    return parent
  end

  def parent_url(showcase)

    path=showcase.for_exhibit? ? atrium_exhibit_path(:id=>showcase.showcases_id, :f=>params[:facet_selection]) :  atrium_collection_showcase_path(:id=>showcase.showcases_id, :showcase_id=>showcase.id) #atrium_collection_showcases_path(showcase.showcases_id)
    return path
  end

  def unset_edit_showcase_in_session
    session[:edit_showcase] = nil
  end
end
