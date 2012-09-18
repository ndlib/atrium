# TODO: This concept should be proposed to Blacklight core
# as something to add into. Be it as an callback for the search
# or some process therein.
class SelectedItemsController < ApplicationController

  def index
    @searches = current_user.searches
  end

  def save
    success = true
    existing_selected_items = current_user.selected_document_ids
    @selected_items = params[:items] || []
    @selected_items.delete_if {|key, value| existing_selected_items.include?(value[:document_id]) }
    @selected_items.each do |key, item|
      success = false unless current_user.selected_items.create(item)
    end
    if @selected_items.length > 0 && success
      flash[:notice] = 'Selected items '+ @selected_items.length.to_s + ' was saved successfully.'
    elsif @selected_items.length > 0
      flash[:error] = 'Error saving selected items'
    end

    redirect_to :back
  end
end