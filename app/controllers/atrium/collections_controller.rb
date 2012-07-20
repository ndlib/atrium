class Atrium::CollectionsController < Atrium::BaseController

  before_filter :initialize_collection, :except=>[:index, :new]

  def new
    create
  end

  def create
    @atrium_collection = Atrium::Collection.new
    @atrium_collection.save
    redirect_to :action => "edit", :id=>@atrium_collection.id
  end

  #def update_embedded_search
  #  render :partial => "shared/featured_search", :locals=>{:content=>params[:content_type]}
  #end

  def home_page_text_config
    @atrium_collection= Atrium::Collection.find(params[:id])
  end

  def set_collection_scope
    session[:copy_folder_document_ids] = session[:folder_document_ids]
    session[:folder_document_ids] = []
    @atrium_collection = Atrium::Collection.find(params[:id])
    session[:folder_document_ids] = @atrium_collection.filter_query_params[:solr_doc_ids].split(',') if @atrium_collection.filter_query_params && @atrium_collection.filter_query_params[:solr_doc_ids]
    p = params.dup
    p.delete :action
    p.delete :id
    p.delete :controller
    #make sure to pass in a search_fields parameter so that it shows search results immediately
    redirect_to catalog_index_path(p)
  end

  def unset_collection_scope
     @atrium_exhibit= Atrium::Exhibit.new
     @atrium_collection = Atrium::Collection.find(params[:id])
     @atrium_collection.update_attributes(:filter_query_params=>nil)
     flash[:notice] = 'Collection scope removed successfully'
     render :action => "edit"
  end

  def show
    @exhibit_navigation_data = get_exhibit_navigation_data

    if(params[:collection_number])
      @collection = Atrium::Collection.find(params[:collection_number])
      @atrium_showcase= Atrium::Showcase.with_selected_facets(@collection.id,@collection.class.name, params[:f]).first
    elsif(params[:id])
      @atrium_collection= Atrium::Collection.find(params[:id])
      @atrium_showcase= Atrium::Showcase.with_selected_facets(@atrium_collection.id,@atrium_collection.class.name, params[:f]).first
    end
    @collection_items_response, @collection_items_documents=get_solr_documents_from_asset(@atrium_collection)
    if(params[:showcase_id] && @atrium_showcase.nil?)
      @atrium_showcase = Atrium::Showcase.find(params[:showcase_id])
    end
    @featured_response, @featured_documents=get_solr_documents_from_asset(@atrium_showcase) unless @atrium_showcase.nil?
    @description_hash=get_description_for_showcase(@atrium_showcase) unless @atrium_showcase.nil?
  end

  def edit
    #@atrium_collection = Atrium::Collection.find(params[:id])
    @exhibit_navigation_data = get_exhibit_navigation_data
    @atrium_exhibit= Atrium::Exhibit.new
  end

  def update
    @atrium_collection = Atrium::Collection.find(params[:id])
    @atrium_exhibit=Atrium::Exhibit.new
    if (params[:atrium_collection])
      params[:atrium_collection][:search_facet_names] ||= []
      params[:atrium_collection][:search_facet_names].delete_if { |elem| elem.empty? }  if params[:atrium_collection][:search_facet_names].length > 0
    end
    respond_to do |format|
      if @atrium_collection.update_attributes(params[:atrium_collection])
        refresh_collection
        flash[:notice] = 'Collection was successfully updated.'
        format.html  { render :action => "edit" }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @atrium_exhibit= Atrium::Exhibit.new
    @atrium_collection = Atrium::Collection.find(params[:id])
    @atrium_collection.destroy
    flash[:notice] = 'Collection deleted.'
    redirect_to catalog_index_path
  end
=begin
  # Just return nil for collection facet limit because we want to display all values for browse links
  def facet_limit_for(facet_field)
    return nil
  end
  helper_method :facet_limit_for

  # Returns complete hash of key=facet_field, value=limit.
  # Used by SolrHelper#solr_search_params to add limits to solr
  # request for all configured facet limits.
  def facet_limit_hash
    Blacklight.config[:facet][:limits]
  end
  helper_method :facet_limit_hash
=end
end


def initialize_collection
  if collection_id = determine_collection_id
    return __initialize_collection( collection_id )
  else
    return false
  end
end

#protected :initialize_collection

private

def determine_collection_id
  if params.has_key? :collection_id
      return params[:collection_id]
  elsif params.has_key? :id
    return params[:id]
  elsif params.has_key? :collection_number
    return params[:collection_number]
  end
end

def refresh_collection
  @exhibit_navigation_data = get_exhibit_navigation_data
end

def refresh_browse_level_label(atrium_collection)
  if params[:atrium_collection][:browse_levels_attributes]
    params[:atrium_collection][:browse_levels_attributes].each_pair do |index,values|
      if values[:solr_facet_name] && !values[:label]
        #reset label if facet changing and other label not supplied
        new_label = facet_field_labels[values[:solr_facet_name]]
        unless new_label.nil? || new_label.empty?
          atrium_collection.browse_levels.each_with_index do |browse_level,index|
            if browse_level.solr_facet_name == values[:solr_facet_name]
              atrium_collection.browse_levels[index].label = new_label
              atrium_collection.save!
              break
            end
          end
        end
      end
    end
  end
end
