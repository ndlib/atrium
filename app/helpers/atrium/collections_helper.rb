module Atrium
  module CollectionsHelper
    def get_saved_search
      saved_search=Atrium.saved_searches_for(atrium_user)
      query_params=[]
      filter_query_params={}
      logger.debug("Search result: #{saved_search.inspect}")
      saved_search.each { |search|
        filter_query_params[:f]=search.query_params[:f] if search.query_params.has_key?(:f)
        filter_query_params[:q]=search.query_params[:q]  if search.query_params.has_key?(:q)
        #search.query_params.delete :action
        #search.query_params.delete :id
        #search.query_params.delete :controller
        #search.query_params.delete :utf8
        #search.query_params.delete :browse_level_id
        #search.query_params.delete :collection_id
        #search.query_params.delete :exhibit_id
        #search.query_params.delete :exclude_browse_level_filter
        #search.query_params.delete :page
        #
        #search.query_params.delete :exclude_browse_level_filter
        #search.query_params.delete :exclude_browse_level_filter
        query_params << filter_query_params
      }
      #logger.debug(query_params.inspect)
      query_params
    end

    def get_saved_items
      saved_items=Atrium.saved_items_for(atrium_user)
      items=[]
      saved_items.each { |item|
        temp={}
        temp[:id]=item.document_id
        temp[:title]=item.title
        #temp[item.document_id]=item.title
        items<<temp
      }
      logger.debug(saved_items.inspect)
      items
    end
  end
end
