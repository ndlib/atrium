class Atrium::ExhibitFacetOrderController < Atrium::BaseController
  def index
    @facet_order = Atrium::Exhibit.find(params[:id]).facet_order rescue nil

    respond_to do |format|
      format.json  { render :json => @facet_order }
    end
  end

  # NOTE this action is not currently protected from unauthorized use.
  def update
    @exhibit = Atrium::Exhibit.find(params[:id])
    @exhibit.facet_order = params[:collection]

    respond_to do |format|
      format.json  { render :json => @exhibit.facet_order }
    end
  end
end
