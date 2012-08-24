require 'spec_helper'

describe Atrium::ExhibitsController do

  def do_new
    get :new
  end

  def do_create
    post :create, :exhibit=>{:title=>"new exhibit"}
  end
  def do_edit
    get :edit
  end

  def do_update
    put :update, :exhibit=>{:title=>"new exhibit", :slug=>"url_slug"}
  end

  before(:each) do
    @collection = mock_model(Atrium::Collection)
    controller.should_receive(:find_collection).and_return(@collection)
    @exhibit = mock_model(Atrium::Exhibit)
    @exhibits=mock("Collection exhibits", :build => @exhibit, :find=>@exhibit)
    @collection.should_receive(:exhibits).and_return(@exhibits)
  end


  describe "Get New"   do
    it "should build exhibit" do
      @exhibits.should_receive(:build).and_return(@exhibit)
      do_new
    end

    it "should assign exhibit" do
      do_new
      assigns(:exhibit).should == @exhibit
    end

    it "should render new template" do
      do_new
      response.should render_template("new")
    end
  end

  describe "Post create"   do
    before(:each) do
      @exhibit.should_receive(:save!).and_return(true)
    end

    it "should be redirect" do
      do_create
      response.should be_redirect
    end

    it "should assign exhibit" do
      do_create
      assigns(:exhibit).should == @exhibit
    end

    it "should redirect to the edit path" do
      do_create
      response.should redirect_to(edit_collection_exhibit_path(@collection, @exhibit))
    end
  end

  describe "Get Edit"   do

    it "should assign exhibit" do
      do_edit
      assigns(:exhibit).should == @exhibit
    end

    it "should render edit template" do
      do_edit
      response.should render_template("edit")
    end
  end

  describe "Put Update"   do
    before(:each) do
      @exhibit.should_receive(:update_attributes).and_return(true)
    end
    it "should assign exhibit" do
      do_update
      assigns(:exhibit).should == @exhibit
    end

    it "should render edit" do
      do_update
      response.should render_template("edit")
    end

  end

  describe "Delete" do
    it "destroy exhibit successfully" do
      @collection= mock_model(Atrium::Collection)
      delete :destroy, { :id => "1" }
      flash[:notice].should == "Exhibit 1 was deleted successfully."
    end

    it "redirects to collection edit" do
      delete :destroy, { :id => "1" }
      response.should redirect_to(edit_collection_path(@collection))
    end
  end
end
