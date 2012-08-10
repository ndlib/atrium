require_dependency "atrium/application_controller"

module Atrium
  class ExhibitsController < ApplicationController
    before_filter :find_collection
    before_filter :find_exhibit, :only => [:edit, :update, :destroy]
    def new
      @exhibit = Atrium::Exhibit.new
    end

    def create
      @exhibit = @collection.exhibits.build(params[:exhibit])
      if @exhibit.save!
        flash[:notice] = 'Exhibit was successfully created.'
        redirect_to :action => "edit", :id=>@exhibit.id
      else
        render :action => "new"
      end
    end

    def edit

    end

    def update
      if @exhibit.update_attributes(params[:exhibit])
        flash[:notice] = 'Exhibit was successfully updated.'
      end
      redirect_to :action => "edit"
    end

    def show
      @showcases = @exhibit.showcases
    end

    def destroy
      @exhibit.destroy
      flash[:notice] = 'Exhibit '+params[:id] +' was deleted successfully.'
      redirect_to edit_collection_path(@collection)
    end

    private
      def find_exhibit
        @exhibit = Atrium::Exhibit.find(params[:id])
      end

      def find_collection
        begin
          if params[:collection_id]
            @collection = Atrium::Collection.find(params[:collection_id])
          elsif params[:exhibit_id]
            @exhibit = Atrium::Exhibit.find(params[:exhibit_id])
            @collection = @exhibit.collection
          else
            raise "Could not find collection_id"
          end
        rescue ActiveRecord::RecordNotFound
          flash.alert = t("Atrium.collection.or.exhibit.not_found")
          redirect_to redirect_target and return
        end
      end
  end
end
