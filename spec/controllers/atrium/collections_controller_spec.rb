require 'spec_helper'

describe Atrium::CollectionsController do

  before(:each) { @routes = Atrium::Engine.routes }


  describe '#find_collection' do
    it 'should return collection object from params id' do
      controller.params[:id] = '1'
      collection=controller.send(:find_collection)
      collection.id.should == 1
    end

    it 'raise error if collection id not available in params' do
      collection=controller.send(:find_collection)
      collection.should_be nil
    end
  end

  before do
    @collection = mock("atrium_collection")
    Atrium::Collection.stub(:find).with("1").and_return(@collection)
    @collection.stub(:id).and_return(1)
    controller.stub(:current_layout).and_return("atrium")
  end

  describe "Get New"   do
    it "build new collection form" do
      controller.stub(:initialize_collection).and_return(@collection)
      get :new
      response.should redirect_to(edit_collection_path(:id=>1))
    end
  end

  describe "POST create" do
    it "redirects to the edit page" do
      controller.stub(:initialize_collection).and_return(@collection)
      post :create
      response.code.should == "302"
      response.should redirect_to(edit_collection_path(:id=>1))
    end
  end



end
