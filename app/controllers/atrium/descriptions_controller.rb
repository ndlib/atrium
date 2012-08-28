require_dependency "atrium/application_controller"

module Atrium
  class DescriptionsController < ApplicationController
    before_filter :find_description, :only => [:edit, :update, :destroy, :show]

    def index
      @descriptions = showcase.descriptions(params[:description])
    end

    def new
      @description = showcase.descriptions.build(params[:description])
      @description.build_essay(:content_type=>"essay")
      @description.build_summary(:content_type=>"summary")
    end

    def create
      @description = showcase.descriptions.build(params[:description])
      if @description.save!
        flash[:notice] = 'Description was successfully created.'
        render :action => "edit"
      else
        render :action => "new"
      end
    end

    def edit
      @description.build_essay(:content_type=>"essay") unless @description.essay
      @description.build_summary(:content_type=>"summary") unless @description.summary
    end

    def update
      if @description.update_attributes(params[:description])
        flash[:notice] = 'Description was successfully updated.'
      else
        flash.now.alert = 'Description update failed'
      end
      render :action => "edit"
    end

    def destroy
      @description.destroy
      flash[:notice] = 'Description '+@description.pretty_title + ' was deleted successfully.'
      redirect_to edit_showcase_path(@showcase)
    end

    private

    def showcase
      @showcase ||=find_showcase
    end

    def find_description
      @description=showcase.descriptions.find(params[:id])
    end

    def find_showcase
      if(params[:showcase_id])
        @showcase=Atrium::Showcase.find(params[:showcase_id])
        @collection=@showcase.for_exhibit? ? @showcase.parent.collection :  @showcase.parent
        @showcase
      else
        flash.alert = t("Atrium.showcase.not_found")
        redirect_to redirect_target and return
      end

    end
  end
end
