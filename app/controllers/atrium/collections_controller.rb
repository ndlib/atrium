require_dependency "atrium/application_controller"

module Atrium
  class CollectionsController < ApplicationController
    before_filter :find_collection, :only => [:edit, :update, :destroy]
    def index
      @collections = Collection.all
    end

    def new
      create
    end

    def create
      @collection = Atrium::Collection.new
      if @collection.save
        flash[:notice] = "Collection created successfully"
        redirect_to edit_collection_path(:id=>@collection.id)
      else
        flash.now.alert = "Collection not created successfully"
        render :action => "new"
      end
    end

    def edit

    end

    def show
      @collection = Atrium::Collection.find(params[:id])
      @exhibits = @collection.exhibits
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
      if @collection.update_attributes(params[:collection])
        flash[:notice] = 'Collection was successfully updated.'
      else
        flash.now.alert = "Collection Not updated"
      end
      render :action => "edit"
    end

    def find_collection
      if params.has_key? :id
        @collection = Atrium::Collection.find(params[:id])
      else
        raise(RuntimeError, "Collection id not found.")
      end
    end

    protected :find_collection
  end
end
