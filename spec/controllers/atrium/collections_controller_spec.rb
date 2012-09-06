require 'spec_helper'

describe Atrium::CollectionsController do

  def do_new
    get :new
  end

  def do_create
    post :create, collection:{title:"new collection", slug:"url_slug"}
  end
  def do_edit
    get :edit
  end

  def do_update
    put :update, collection:{title:"new collection", slug:"url_slug"}
  end


  describe "Get New"   do
    before(:each) do
      Atrium::Collection.stub!(:new).and_return(@collection = mock_model(Atrium::Collection, save:true))
    end

    it "should build collection" do
      Atrium::Collection.should_receive(:new).and_return(@collection)
      do_new
    end

    it "should assign collection" do
      do_new
      assigns(:collection).should == @collection
    end

    it "should render new template" do
      do_new
      response.should render_template("new")
    end
  end

  describe "Post create"   do
    before(:each) do
      Atrium::Collection.stub!(:new).and_return(@collection = mock_model(Atrium::Collection, save:true))
    end

    it "should create the collection" do
      Atrium::Collection.should_receive(:new).and_return(@collection)
      do_create
    end

    it "should save the collection item" do
      @collection.should_receive(:save).and_return(true)
      do_create
    end

    it "should be redirect" do
      do_create
      response.should be_redirect
    end

    it "should assign collection" do
      do_create
      assigns(:collection).should == @collection
    end

    it "should redirect to the edit path" do
      do_create
      response.should redirect_to(edit_collection_path(@collection))
    end
  end

  describe "Get Edit"   do
    before(:each) do
      Atrium::Collection.stub!(:find).and_return(@collection = mock_model(Atrium::Collection))
    end

    it "should assign collection" do
      do_edit
      assigns(:collection).should == @collection
    end

    it "should render edit template" do
      do_edit
      response.should render_template("edit")
    end
  end

  describe "Put Update"   do
    before(:each) do
      Atrium::Collection.stub!(:find).and_return(@collection = mock_model(Atrium::Collection))
      @collection.stub!(:update_attributes).and_return(true)
    end

    it "should assign collection" do
      do_update
      assigns(:collection).should == @collection
    end

    it "should render edit template" do
      do_update
      response.should render_template("edit")
    end
  end

  describe "Delete" do
    before do
      Atrium::Collection.stub!(:find).and_return(@collection = mock_model(Atrium::Collection))
      @collection.should_receive(:destroy).and_return(true)
      @collection.should_receive(:pretty_title).and_return("collection_title")
    end
    it "destroy collection successfully" do
      delete :destroy, { id: "1" }
      flash[:notice].should == "Collection collection_title was deleted successfully."
    end

    it "redirects to collection index" do
      delete :destroy, { id: "1" }
      response.should redirect_to(collections_path)
    end
  end



end
