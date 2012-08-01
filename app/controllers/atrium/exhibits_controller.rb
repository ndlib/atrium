require_dependency "atrium/application_controller"

module Atrium
  class ExhibitsController < ApplicationController
  
    def show
    end

    def new
      @exhibit = Atrium::Exhibit.new
      respond_to do |format|
        format.html
      end
    end

    def create
      @exhibit = Atrium::Exhibit.new(params[:exhibit])
      if @exhibit.update_attributes(params[:exhibit])
        flash[:notice] = 'Exhibit was successfully created.'
        redirect_to :controller=>"atrium/collections", :action => "edit", :id=>@exhibit.atrium_collection_id
      end
    end

    def edit
      @exhibit = Atrium::Exhibit.find(params[:id])
      @collection = @exhibit.collection
      #@exhibit_navigation_data = get_exhibit_navigation_data
    end

    def update
      @exhibit = Atrium::Exhibit.find(params[:id])
      if @exhibit.update_attributes(params[:atrium_exhibit])
        flash[:notice] = 'Exhibit was successfully updated.'
      end
      redirect_to :action => "edit"
    end

  end
end
