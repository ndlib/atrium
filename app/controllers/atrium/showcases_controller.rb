require_dependency "atrium/application_controller"

module Atrium
  class ShowcasesController < ApplicationController
    before_filter :find_parent
    def new
      if @parent
        @showcase=@parent.showcases.build
      end
        #redirect edit_showcase_to_add_feature_desc
    end



    def create
      if parent
        @showcase=@parent.showcases.build
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
  
    def edit
    end
  
    def show
    end

    private

    def find_parent
      case
        when params[:exhibit_id] then @parent= Atrium::Exhibit.find_by_id(params[:exhibit_id])
        when params[:collection_id] then @parent = Atrium::Collection.find_by_id(params[:collection_id])
      end
    end

    def parent_url(showcase)
      path=showcase.for_exhibit? ? atrium_exhibit_path(:id=>showcase.showcases_id, :f=>params[:facet_selection]) :  atrium_collection_showcase_path(:id=>showcase.showcases_id, :showcase_id=>showcase.id) #atrium_collection_showcases_path(showcase.showcases_id)
      return path
    end

    def find_collection
      if @parent.is_a?(Atrium::Collection)
        @collection = @parent
      elsif @parent.is_a?(Atrium::Exhibit)
        @collection = @parent.collection
      end
    end
  end
end
