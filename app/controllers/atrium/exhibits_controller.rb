require_dependency "atrium/application_controller"

module Atrium
  class ExhibitsController < ApplicationController
  
    def new
      @exhibit = Atrium::Exhibit.new(:atrium_collection_id=>params[:collection_id], :set_number=>params[:set_number])
      respond_to do |format|
        format.html
      end
    end

    def create
      @exhibit = Atrium::Exhibit.new(params[:exhibit])
      if @exhibit.update_attributes(params[:exhibit])
        flash[:notice] = 'Exhibit was successfully created.'
      end
    end

    def edit
      @exhibit = Atrium::Exhibit.find(params[:id])
      @collection = @exhibit.collection
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

  end
end
