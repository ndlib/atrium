require 'spec_helper'

describe Atrium::CollectionsController do

  before(:each) { @routes = Atrium::Engine.routes }


  describe '#determine_collection_id' do
    it 'should return collection id from params id' do
      controller.params[:id] = '1'
      collection_id=controller.send(:determine_collection_id)
      collection_id.should == '1'
    end

    it 'should return collection id from params collection id' do
      controller.params[:collection_id] = '1'
      collection_id=controller.send(:determine_collection_id)
      collection_id.should == '1'
    end

    it 'return nil if collection id not available in params' do
      collection_id=controller.send(:determine_collection_id)
      collection_id.should == nil
    end
  end

  before do
    @collection = mock("atrium_collection")
    Atrium::Collection.stub(:find).with("1").and_return(@collection)
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
