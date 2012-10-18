require_dependency "atrium/application_controller"

module Atrium
  class ShowcasesController < ApplicationController
    before_filter :find_showcase, only: [:edit, :update, :destroy, :show]

    def new
      @showcase=parent.showcases.build(params[:showcase])
    end

    def create
      @showcase=parent.showcases.build(params[:showcase])
      if @showcase.save!
        flash[:notice] = 'Showcase was successfully created.'
        render action: "edit"
      else
        render action: "new"
      end
    end

    def index
      @showcases=parent.showcases
    end

    def update
      if (params[:showcase])
        params[:showcase][:showcase_items] ||= []
        if params[:showcase][:showcase_items].length > 0
          params[:showcase][:showcase_items].delete_if { |elem| elem.empty? }
        end
      end
      if @showcase.update_attributes(params[:showcase])
        flash[:notice] = 'Showcase was successfully updated.'
      else
        flash.now.alert = 'Showcase Not updated'
      end
      render action: "edit"
    end

    def edit
    end

    def show
    end

    def destroy
      redirect_url=parent_url
      @showcase.destroy
      flash[:notice] = 'Showcase '+params[:id] +' was deleted successfully.'
      redirect_to redirect_url
    end

    def add_or_update
      @parent=parent
      #TODO move it model
      @showcase= Atrium::Showcase.with_selected_facets(
        @parent.id,
        @parent.class.name,
        params[:facet_selection]
      ).first
      logger.debug("Showcase: #{@showcase.inspect}")
      unless  @showcase
        @showcase = @parent.showcases.build(
          {
            showcases_id:@parent.id,
            showcases_type:@parent.class.name
          }
        )
        @showcase.save!
        if(params[:facet_selection])
          params[:facet_selection].collect {|key,value|
            @showcase.facet_selections.create(
              {solr_facet_name:key,value:value.first}
            )
          }
          @showcase.save!
        end
      end
      render action: "edit"
    end

    private

    def find_showcase
      @showcase=parent.showcases.find(params[:id])
    end

    def parent
      @parent ||=find_parent
      find_collection(@parent)
      @parent
    end

    def find_parent
      case
      when params[:exhibit_id] then
        @parent= Atrium::Exhibit.find(params[:exhibit_id])
      when params[:collection_id] then
        @parent = Atrium::Collection.find(params[:collection_id])
      when params[:id] then
        @showcase = Atrium::Showcase.find(params[:id])
        @parent = @showcase.collection
      else
        flash.alert = t("Atrium.showcase.parent.not_found")
        redirect_to(:back)
      end
    end

    def parent_url
      parent.is_a?(Atrium::Exhibit) ?
        exhibit_showcases_path(parent) :
        edit_collection_path(parent)
    end

    def collection
      @collection ||= find_parent
    end

    def find_collection(parent)
      @collection = parent.collection
    end
  end
end
