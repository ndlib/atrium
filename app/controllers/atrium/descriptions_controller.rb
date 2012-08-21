require_dependency "atrium/application_controller"

module Atrium
  class DescriptionsController < ApplicationController
    before_filter :find_description, :only => [:edit, :update, :destroy]
    before_filter :find_collection

    def index
      @descriptions = @showcase.descriptions
    end

    def new
      @description = @showcase.descriptions.build
      @description.build_essay(:content_type=>"essay")
      @description.build_summary(:content_type=>"summary")
    end

    def create
      @description = @showcase.descriptions.build(params[:description])
      if @description.save!
        flash[:notice] = 'Description was successfully created.'
        redirect_to :action => "edit", :id=>@description.id
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

    def find_description
      @description=Atrium::Description.find(params[:id])
    end

    def find_showcase
      @showcase=Atrium::Showcase.find(params[:showcase_id])
    end

    def find_collection
      find_showcase
      if @showcase && @showcase.parent
        @collection=@showcase.for_exhibit? ? @showcase.parent.collection :  @showcase.parent
      end
    end
  end
end
