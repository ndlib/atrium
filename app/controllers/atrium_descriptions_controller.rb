class AtriumDescriptionsController < AtriumController

  before_filter :initialize_collection, :get_exhibit_navigation_data

  def index
    atrium_showcase=Atrium::Showcase.find(params[:showcase_id])
    @atrium_descriptions = atrium_showcase.descriptions
    @description_hash=get_description_for_showcase(atrium_showcase)
    respond_to do |want|
      want.inline {
        render :action =>'index.html', :layout=>false
      }
    end
  end

  def new
    @atrium_description = Atrium::Description.new(:atrium_showcase_id=>params[:showcase_id])
    @atrium_description.build_essay(:content_type=>"essay")
    @atrium_description.build_summary(:content_type=>"summary")
  end

  def create
    logger.debug("in create params: #{params.inspect}")
    @atrium_description = Atrium::Description.new(:atrium_showcase_id=>params[:showcase_id])
    @atrium_description.save!
    logger.info("@atrium_description = #{@atrium_description.inspect}")
    if @atrium_description.save
      @atrium_description.update_attributes(params[:atrium_description])
      flash[:notice] = 'Description was successfully created.'
      redirect_to :action => "edit", :id=>@atrium_description.id
    else
      render :action => "new"
    end
  end

  def edit
    @atrium_description = Atrium::Description.find(params[:id])
    logger.debug("Desc: #{@atrium_description.inspect}, essay = #{@atrium_description.essay.inspect},summary = #{@atrium_description.summary.inspect}")
    @atrium_description.build_essay(:content_type=>"essay") unless @atrium_description.essay
    @atrium_description.build_summary(:content_type=>"summary") unless @atrium_description.summary
  end

  def update
    @atrium_description = Atrium::Description.find(params[:id])
    logger.debug("params: #{params[:atrium_description]}")
    if((params[:atrium_description]) && @atrium_description.update_attributes(params[:atrium_description]))
      logger.debug("@atrium_description = #{@atrium_description.inspect}")
      logger.debug("essay updated as = #{@atrium_description.essay.inspect}")
      flash[:notice] = 'Description was successfully updated.'
    elsif(params[:essay_attributes] && @atrium_description.essay.update_attributes(params[:essay_attributes]))
      #if @atrium_description.essay.update_attributes(params[:essay_attributes])
        #refresh_browse_level_label(@atrium_collection)
        logger.debug("@atrium_description = #{@atrium_description.inspect}")
        logger.debug("essay updated as = #{@atrium_description.essay.inspect}")
        flash[:notice] = 'Description was successfully updated.'
      #end
    else
      logger.debug("into else: #{@atrium_description.inspect}")
      if @atrium_description.update_attributes(params[:atrium_description])
        #refresh_browse_level_label(@atrium_collection)
        flash[:notice] = 'Exhibit was successfully updated.'
      end
    end
    redirect_to :action => "edit", :id=>@atrium_description.id
  end

  def show
    @atrium_description = Atrium::Description.find(params[:id])
    @description_hash={}
    unless @atrium_description.description_solr_id.nil?
      p = params.dup
      params.delete :f
      params.delete :q
      desc_response, desc_documents = get_solr_response_for_field_values("id",@atrium_description.description_solr_id)
      desc_documents.each do |doc|
        @description_hash[doc["id"]]= doc["description_content_s"].blank? ? "" : doc["description_content_s"].first
      end
      params.merge!(:f=>p[:f])
      params.merge!(:q=>p[:q])
    end
  end

  def save_ids_to_descriptions
    unless session[:folder_document_ids].empty?
      description_hash={}
      desc_response, desc_documents = get_solr_response_for_field_values("id",session[:folder_document_ids])
      desc_documents.each do |doc|
        desc_hash={}
        desc_hash["page_display"]= doc["page_display_s"].blank? ? "" : doc["page_display_s"].first
        desc_hash["title"]= doc["title_s"].blank? ? "" : doc["title_s"].first
        description_hash[doc["id"]]=desc_hash
      end
      session[:folder_document_ids].each do |solr_id|
        doc = description_hash[solr_id]
        @atrium_description = Atrium::Description.new(:atrium_showcase_id=>params[:showcase_id], :description_solr_id=>solr_id, :page_display=>doc["page_display"], :title=>doc["title"])
        @atrium_description.save!
      end
      #logger.debug("Copy of session#{session[:copy_folder_document_ids].inspect}")
      session_folder_ids=[] || session[:copy_folder_document_ids]
      session[:folder_document_ids] = session_folder_ids
      session[:copy_folder_document_ids]=nil
      #logger.debug("folders_selected: #{session[:folder_document_ids].inspect}")
    end
    redirect_to :action => "index", :showcase_id=>params[:showcase_id]
  end

  def destroy
    #Need to delete in AJAX way
    @atrium_description = Atrium::Description.find(params[:id])
    Atrium::Description.destroy(params[:id])
    text = 'Description'+params[:id] +'was deleted successfully.'
    render :text => text
  end

  def add_from_solr
    session[:copy_folder_document_ids] = session[:folder_document_ids]
    session[:folder_document_ids] = []
    @atrium_showcase=Atrium::Showcase.find(params[:showcase_id])
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
    solr_desc_arr=[]
    @atrium_showcase.descriptions.each do |desc|
      solr_desc_arr<<desc.description_solr_id
    end
    session[:folder_document_ids] = solr_desc_arr.uniq
    #make sure to pass in a search_fields parameter so that it shows search results immediately
    redirect_to catalog_index_path(:add_description=>true,:collection_id=>collection_id,:exhibit_id=>exhibit_id,:search_field=>"all_fields",:f=>{"active_fedora_model_s"=>["Description"]})
  end

  def blacklight_config
    CatalogController.blacklight_config
  end


end
