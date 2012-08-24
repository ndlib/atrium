require_dependency "atrium/application_controller"

module Atrium
  class ShowcasesController < ApplicationController
    before_filter :find_showcase, :only => [:edit, :update, :destroy, :show]

    def new
      @showcase=find_parent.showcases.build(params[:showcase])
    end

    def create
      @showcase=find_parent.showcases.build(params[:showcase])
      if @showcase.save!
        flash[:notice] = 'Showcase was successfully created.'
        redirect_to :action => "edit", :id=>@showcase.id
      else
        render :action => "new"
      end
    end
  
    def index
    end

    def update
      if (params[:showcase])
        params[:showcase][:showcase_items] ||= []
        params[:showcase][:showcase_items].delete_if { |elem| elem.empty? }  if params[:showcase][:showcase_items].length > 0
      end
      if @showcase.update_attributes(params[:showcase])
        flash[:notice] = 'Showcase was successfully updated.'
      else
        flash.now.alert = "Showcase Not updated"
      end
      render :action => "edit"
    end
  
    def edit
    end
  
    def show
    end

    def destroy
      @showcase.destroy
      flash[:notice] = 'Showcase '+params[:id] +' was deleted successfully.'
      redirect_to parent_url(@showcase)
    end

    def add_featured

    end

    def remove_featured

    end

    def parent
      redirect_to parent_url(find_showcase)
    end

    private

    def find_showcase
      @showcase=find_parent.showcases.find(params[:id])
      logger.debug(@showcase.inspect)
    end

    def find_parent
      case
        when @showcase then
          @parent=@showcase.parent
          @collection = @showcase.for_exhibit? ? @parent.collection :  @parent
        when params[:exhibit_id] then
          @parent= Atrium::Exhibit.find_by_id(params[:exhibit_id])
          @collection =  @parent.collection
        when params[:collection_id] then
          @parent = Atrium::Collection.find_by_id(params[:collection_id])
          @collection =  @parent
      end
    end

    def parent_url(showcase)
      path=showcase.for_exhibit? ? edit_collection_exhibit_path(:id=>@parent.id, :collection_id=>@collection.id) :  edit_collection_path(@parent)
      return path
    end

    def collection
      @collection ||= find_parent
    end

    #def find_collection
    #  if find_parent
    #    if @parent.is_a?(Atrium::Collection)
    #      @collection = @parent
    #    elsif @parent.is_a?(Atrium::Exhibit)
    #      @collection = @parent.collection
    #    end
    #  end
    #end
  end
end
