require_dependency "atrium/application_controller"

module Atrium
  class CollectionsController < ApplicationController

    def index
      @collections = Collection.all
    end

    def new
      @collection = Atrium::Collection.new(params[:collection])
    end

    def create
      if (params[:collection])
        params[:collection][:search_facet_names] ||= []
        params[:collection][:search_facet_names].delete_if { |elem| elem.empty? }  if params[:collection][:search_facet_names].length > 0
      end
      @collection = Atrium::Collection.new(params[:collection])
      if @collection.save
        flash[:notice] = "Collection created successfully"
        redirect_to edit_collection_path(@collection)
      else
        flash.now.alert = "Collection not created successfully"
        render :action => "new"
      end
    end

    def edit

    end

    def show
      @exhibits = collection.exhibits
      respond_to do |format|
        format.html
        format.atom { render :layout => false }
      end
    end

    def update
      if (params[:collection])
        params[:collection][:search_facet_names] ||= []
        params[:collection][:search_facet_names].delete_if { |elem| elem.empty? }  if params[:collection][:search_facet_names].length > 0
      end
      if collection.update_attributes(params[:collection])
        flash[:notice] = 'Collection was successfully updated.'
      else
        flash.now.alert = "Collection Not updated"
      end
      render :action => "edit"
    end

    def destroy
      collection.destroy
      flash[:notice] = 'Collection '+ @collection.pretty_title+' was deleted successfully.'
      redirect_to collections_path
    end

    def collection
      @collection ||= Atrium::Collection.find(params[:id])
    end
    protected :collection
    helper_method :collection
  end
end
