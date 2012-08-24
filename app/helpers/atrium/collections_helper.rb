module Atrium
  module CollectionsHelper
    def can_add_view_exhibit?
      return true
    end

    def get_saved_search
      saved_search=Atrium.saved_searches_for(atrium_user)
      query_params=[]
      saved_search.each { |search|
        search.query_params.delete :action
        search.query_params.delete :id
        search.query_params.delete :controller
        search.query_params.delete :utf8
        search.query_params.delete :browse_level_id
        search.query_params.delete :collection_id
        search.query_params.delete :exhibit_id
        search.query_params.delete :exclude_browse_level_filter
        query_params << search.query_params
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
      #logger.debug(saved_items.inspect)
      items
    end
  end
end
