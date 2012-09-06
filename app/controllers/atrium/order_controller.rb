require_dependency "atrium/application_controller"

module Atrium
  class OrderController < ApplicationController
    def exhibit_index
      respond_to do |format|
        format.json  { render json: collection.exhibit_order }
      end
    end

    def exhibit_facet_index
      respond_to do |format|
        format.json  { render json: exhibit.facet_order }
      end
    end


    def collection_showcase_index
      respond_to do |format|
        format.json  { render json: collection.showcase_order }
      end
    end


    def exhibit_showcase_index
      respond_to do |format|
        format.json  { render json: exhibit.showcase_order }
      end
    end


    # NOTE this action is not currently protected from unauthorized use.
    def update_collection_exhibits_order
      collection.exhibit_order = params[:collection]

      respond_to do |format|
        format.json  { render json: collection.exhibit_order }
      end
    end

    def update_exhibit_facets_order
      exhibit.facet_order = params[:collection]

      respond_to do |format|
        format.json  { render json: collection.exhibit_order }
      end
    end

    def update_exhibit_showcases_order
      exhibit.showcase_order = params[:collection]

      respond_to do |format|
        format.json  { render json: collection.exhibit_order }
      end
    end

    def update_collection_showcases_order
      collection.showcase_order = params[:collection]

      respond_to do |format|
        format.json  { render json: collection.exhibit_order }
      end
    end

    protected
    def collection
      @collection ||= Atrium::Collection.find(params[:id])
    end

    def exhibit
      @exhibit ||= Atrium::Exhibit.find(params[:id])
    end
  end
end
