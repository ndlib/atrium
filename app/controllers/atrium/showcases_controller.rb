class Atrium::ShowcasesController < Atrium::BaseController

  before_filter :initialize_collection

  def index

    @exhibit = Atrium::Exhibit.find(params[:atrium_exhibit_id])
    @exhibit_navigation_data = get_exhibit_navigation_data

    set_edit_showcase_in_session
    redirect_to atrium_collection_path(:id=>@exhibit.atrium_collection_id, :exhibit_number=>@exhibit.id)
  end

  def new
    @parent=parent_object
    @atrium_showcase= Atrium::Showcase.with_selected_facets(@parent.id, @parent.class.name, params[:facet_selection]).first

    unless  @atrium_showcase

      @atrium_showcase = @parent.showcases.build({:showcases_id=>@parent.id, :showcases_type=>@parent.class.name})
      @atrium_showcase.save!
      if(params[:facet_selection])
        params[:facet_selection].collect {|key,value|
          facet_selection = @atrium_showcase.facet_selections.create({:solr_facet_name=>key,:value=>value.first})

        }
        @atrium_showcase.save!
      end
      logger.info("atrium_showcase = #{@atrium_showcase.inspect}")
    end
    set_edit_showcase_in_session
    if @atrium_showcase.showcases_type=="Atrium::Exhibit"
      redirect_to atrium_exhibit_path(:id=>@atrium_showcase.showcases_id, :f=>params[:facet_selection])
    else
      redirect_to atrium_collection_showcase_path(@atrium_showcase.showcases_id, @atrium_showcase.id, :f=>params[:facet_selection])
    end
  end

  def create

    @atrium_showcase = Atrium::Showcase.new(params[:atrium_exhibit_id])
    @atrium_showcase.showcase_items ||= Hash.new
    logger.info("atrium_showcase = #{@atrium_showcase.inspect}")
    @atrium_showcase.save
    logger.info("atrium_showcase = #{@atrium_showcase.inspect}")
    set_edit_showcase_in_session
    if @atrium_showcase.showcases_type=="Atrium::Exhibit"
      redirect_to atrium_exhibit_path(:id=>@atrium_showcase.showcases_id, :f=>params[:facet_selection])
    else
      redirect_to atrium_collection_showcase_path(@atrium_showcase.showcases_id, @atrium_showcase.id, :f=>params[:facet_selection])
    end
  end

  def edit
    @atrium_showcase = Atrium::Showcase.find(params[:id])
    set_edit_showcase_in_session
    if @atrium_showcase.showcases_type=="atrium_exhibit"
      redirect_to atrium_exhibit_path(:id=>@atrium_showcase.showcases_id, :f=>params[:facet_selection])
    else
      redirect_to atrium_collection_showcase_path(@atrium_showcase.showcases_id, params[:id], :f=>params[:f])
    end
  end

  def update
     @atrium_showcase = Atrium::Showcase.find(params[:showcase_id])
    if @atrium_showcase.update_attributes(params[:atrium_showcase])
      flash[:notice] = 'Browse was successfully updated.'
    end
    redirect_to :action => "edit", :id=>@atrium_showcase.id, :f=>params[:f]
  end

  def show
    @atrium_showcase = Atrium::Showcase.find(params[:showcase_id])
    unless session[:folder_document_ids].blank?
      @atrium_showcase.showcase_items ||= Hash.new
      selected_document_ids = session[:folder_document_ids]
      @atrium_showcase.showcase_items[:type]="featured"
      @atrium_showcase.showcase_items[:solr_doc_ids]=selected_document_ids.join(',')
    else

      @atrium_showcase.showcase_items={}
    end
    @atrium_showcase.save

    session_folder_ids=[] || session[:copy_folder_document_ids]
    session[:folder_document_ids] = session_folder_ids
    session[:copy_folder_document_ids]=nil

    if @atrium_showcase && !@atrium_showcase.showcase_items[:solr_doc_ids].nil?
      @response, @featured_documents = get_solr_response_for_field_values("id",@atrium_showcase.showcase_items[:solr_doc_ids].split(',') || [])
    end
    if params[:no_layout]
      render :layout=>false
    end
  end

  def destroy

  end

  def configure_showcase

    unless  @atrium_showcase
      @atrium_showcase=Atrium::Showcase.find(params[:id])
    end

    @exhibit_navigation_data = get_exhibit_navigation_data

    set_edit_showcase_in_session
    if @atrium_showcase.showcases_type=="Atrium::Exhibit"
      redirect_to atrium_exhibit_path(:id=>@atrium_showcase.showcases_id, :f=>params[:f])
    else
      @atrium_collection= Atrium::Collection.find_by_id(@atrium_showcase.showcases_id)
      redirect_to atrium_collection_showcase_path(@atrium_showcase.showcases_id, params[:id], :f=>params[:f])
    end
  end

  def featured
    session[:copy_folder_document_ids] = session[:folder_document_ids]
    session[:folder_document_ids] = []
    @atrium_showcase = Atrium::Showcase.find(params[:id])
    parent = @atrium_showcase.parent if @atrium_showcase.parent
    if parent.is_a?(Atrium::Collection)
      collection_id = parent.id
    elsif parent.is_a?(Atrium::Exhibit)
      exhibit_id = parent.id
      collection = parent.collection
      collection_id = collection.id if collection
    else
      logger.error("Atrium showcase parent is invalid. Please check the parent")
      collection_id = params[:collection_id]
      exhibit_id = params[:exhibit_id]
    end

    session[:folder_document_ids] = @atrium_showcase.showcase_items[:solr_doc_ids].split(',') unless @atrium_showcase.showcase_items[:solr_doc_ids].nil?
    #make sure to pass in a search_fields parameter so that it shows search results immediately
    redirect_to catalog_index_path(:add_featured=>true,:collection_id=>collection_id,:exhibit_id=>exhibit_id,:search_field=>"all_fields",:f=>params[:f])
  end

  def selected_featured
     @atrium_showcase = Atrium::Showcase.find(params[:id])
    selected_document_ids = session[:folder_document_ids]
    session[:folder_document_ids] = session[:copy_folder_document_ids]

    @response, @documents = get_solr_response_for_field_values("id",selected_document_ids || [])
    render :layout => false, :locals=>{:selected_document_ids=>selected_document_ids}
  end

  def refresh_showcase
    @atrium_showcase = Atrium::Showcase.find(params[:id])
    path=@atrium_showcase.for_exhibit? ? atrium_exhibit_path(:id=>@atrium_showcase.showcases_id, :f=>params[:f]) :  atrium_collection_path(:id=>@atrium_showcase.showcases_id)
    unset_edit_showcase_in_session
    redirect_to path
  end

  def blacklight_config
    CatalogController.blacklight_config
  end


  private

  def parent_object
    case
      when params[:atrium_exhibit_id] then parent= Atrium::Exhibit.find_by_id(params[:atrium_exhibit_id])
      when params[:atrium_collection_id] then parent = Atrium::Collection.find_by_id(params[:atrium_collection_id])
    end

    return parent
  end

  def parent_url(parent)
    case
      when params[:article_id] then article_url(parent)
      when params[:news_id] then news_url(parent)
    end
  end

  def unset_edit_showcase_in_session

    session[:edit_showcase] = nil
  end

end
