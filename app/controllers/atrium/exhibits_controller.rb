require_dependency "atrium/application_controller"

module Atrium
  class ExhibitsController < ApplicationController
    before_filter :initialize_collection
    def new
      @exhibit = Atrium::Exhibit.new
    end

    def create
      #@collection = Atrium::Collection.find(params[:collection_id]) unless @collection
      @exhibit = @collection.exhibits.build(params[:exhibit])
      if @exhibit.save!
        flash[:notice] = 'Exhibit was successfully created.'
        redirect_to :action => "edit", :id=>@exhibit.id
      else
        render :action => "new"
      end
    end

    def edit
      @exhibit = Atrium::Exhibit.find(params[:id])
      #@exhibit_navigation_data = get_exhibit_navigation_data
    end

    def update
      @exhibit = Atrium::Exhibit.find(params[:id])
      if @exhibit.update_attributes(params[:exhibit])
        flash[:notice] = 'Exhibit was successfully updated.'
      end
      redirect_to :action => "edit"
    end

    def show
      @exhibit = Atrium::Exhibit.find(params[:id])
    end

    def destroy
      @exhibit = Atrium::Exhibit.find(params[:id])
      Atrium::Exhibit.destroy(params[:id])
      flash[:notice] = 'Exhibit '+params[:id] +' was deleted successfully.'
      redirect_to edit_collection_path(@exhibit.atrium_collection_id)
    end

    def initialize_collection
      if params[:collection_id]
        @collection = Atrium::Collection.find(params[:collection_id])
        #return __initialize_collection( collection_id )
      else
        raise "Could not find collection_id"
      end
    end

    protected :initialize_collection

  end
end
