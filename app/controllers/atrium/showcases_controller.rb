require_dependency "atrium/application_controller"

module Atrium
  class ShowcasesController < ApplicationController
    before_filter :find_showcase, :only => [:edit, :update, :destroy]
    before_filter :find_collection

    def new
      if @parent
        @showcase=@parent.showcases.build
      end
    end

    def create
      if @parent
        @showcase=@parent.showcases.build(params[:showcase])
      end
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
      @showcase=Atrium::Showcase.find(params[:id])
      logger.debug(@showcase.inspect)
    end

    def find_parent
      case
        when @showcase then @parent=@showcase.parent
        when params[:exhibit_id] then    @parent= Atrium::Exhibit.find_by_id(params[:exhibit_id])
        when params[:collection_id] then @parent = Atrium::Collection.find_by_id(params[:collection_id])
      end
    end

    def parent_url(showcase)
      path=showcase.for_exhibit? ? edit_collection_exhibit_path(:id=>@parent.id, :collection_id=>@collection.id) :  edit_collection_path(@parent)
      return path
    end

    def find_collection
      if find_parent
        if @parent.is_a?(Atrium::Collection)
          @collection = @parent
        elsif @parent.is_a?(Atrium::Exhibit)
          @collection = @parent.collection
        end
      end
    end
  end
end
