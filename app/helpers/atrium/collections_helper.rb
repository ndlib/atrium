module Atrium
  module CollectionsHelper
    def saved_searches_for_select
      get_saved_search.collect do |search|
        query_params = {}

        begin
          query_params[:q] = search[:query_params].fetch(:q)
        rescue NoMethodError, KeyError
        end

        begin
          query_params[:f] = search[:query_params].fetch(:f)
        rescue NoMethodError, KeyError
        end

        [
          strip_tags(
            Atrium.query_param_beautifier(self,query_params).gsub("<"," <")
          ),
          search[:id]
        ]
      end
    end

    def get_saved_search
      Atrium.saved_searches_for(current_user)
    end

    def get_saved_items
      saved_items=Atrium.saved_items_for(current_user)
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
