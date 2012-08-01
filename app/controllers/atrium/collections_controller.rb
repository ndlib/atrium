require_dependency "atrium/application_controller"

module Atrium
  class CollectionsController < ApplicationController
    def index
      @collections = Collection.all
    end

    def new
      create
    end

    def create
      @collection = Collection.new
      @collection.save
      redirect_to :action => "edit", :id=>@collection.id
    end

    def edit
      @collection = Collection.find(params[:id])
      @exhibit= Atrium::Exhibit.new
    end
  
    def show
    end

    def update
      @collection = Atrium::Collection.find(params[:id])
      @exhibit=Atrium::Exhibit.new
      if (params[:atrium_collection])
        params[:atrium_collection][:search_facet_names] ||= []
        params[:atrium_collection][:search_facet_names].delete_if { |elem| elem.empty? }  if params[:atrium_collection][:search_facet_names].length > 0
      end
      respond_to do |format|
        if @collection.update_attributes(params[:collection])
          refresh_collection
          flash[:notice] = 'Collection was successfully updated.'
          format.html  { render :action => "edit" }
        else
          format.html { render :action => "edit" }
        end
      end
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
      #@exhibit_navigation_data = get_exhibit_navigation_data
    end
  end
end
