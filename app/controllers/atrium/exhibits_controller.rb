require_dependency "atrium/application_controller"

module Atrium
  class ExhibitsController < ApplicationController
    before_filter :find_exhibit, :only => [:edit, :update, :destroy, :show]
    def new
      @exhibit = collection.exhibits.build(params[:exhibit])
    end

    def create
      @exhibit = collection.exhibits.build(params[:exhibit])
      if @exhibit.save!
        flash[:notice] = 'Exhibit was successfully created.'
        redirect_to edit_collection_exhibit_path(:id=>@exhibit.id, :collection_id=>@collection)
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
      render :action => "edit"
    end

    def show
      @showcases = @exhibit.showcases
    end

    def destroy
      puts @collection.inspect
      @exhibit.destroy
      flash[:notice] = 'Exhibit '+params[:id] +' was deleted successfully.'
      redirect_to edit_collection_path(@collection)
    end


      def find_exhibit
        @exhibit = collection.exhibits.find(params[:id])
      end

      def collection
        @collection ||= find_collection


      end

      def find_collection
        begin
          logger.debug("Finding collection")
          if params[:collection_id]
            @collection = Atrium::Collection.find(params[:collection_id])
          elsif params[:id]
            @exhibit = Atrium::Exhibit.find(params[:id])
            @collection = @exhibit.collection
          else
            raise "Could not find collection_id"
          end
        rescue ActiveRecord::RecordNotFound
          flash.alert = t("Atrium.collection.or.exhibit.not_found")
          redirect_to redirect_target and return
        end
        @collection
      end
  end
end
