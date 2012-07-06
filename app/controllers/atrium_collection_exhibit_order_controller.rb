class AtriumCollectionExhibitOrderController < ApplicationController
  def index
    respond_to do |format|
      format.json  { render :json => collection.exhibit_order }
    end
  end

  # NOTE this action is not currently protected from unauthorized use.
  def update
    collection.exhibit_order = params[:collection]

    respond_to do |format|
      format.json  { render :json => collection.exhibit_order }
    end
  end

  protected
  def collection
    @collection ||= Atrium::Collection.find(params[:id])
  end
end
