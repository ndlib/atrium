require 'spec_helper'

describe Atrium::ShowcasesController do

  def do_new
    get :new
  end

  def do_create
    post :create, :exhibit=>{:title=>"new showcase for given asset"}
  end
  def do_edit
    get :edit
  end

  def do_update
    put :update, :exhibit=>{:title=>"new exhibit", :slug=>"url_slug"}
  end
  describe "Get #new" do
    before(:each) do
      controller.stub(:find_collection).and_return(@collection = mock_model(Atrium::Collection))
      @showcase = mock_model(Atrium::Showcase)
      @showcases=mock("Mocking showcases", :build => @showcase, :find=>@showcase)
    end
    context "when building showcase for exhibit" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@exhibit = mock_model(Atrium::Exhibit))
        @exhibit.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase for exhibit" do
        do_new
        assigns(:parent).should == @exhibit
        assigns(:showcase).should == @showcase
      end

      it "should render new template" do
        do_new
        response.should render_template("new")
      end
    end
    context "when creating showcase for collection" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@collection)
        @collection.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase for exhibit" do
        do_new
        assigns(:parent).should == @collection
        assigns(:showcase).should == @showcase
      end

      it "should render new template" do
        do_new
        response.should render_template("new")
      end
    end
  end

  describe "Post #create" do
    before(:each) do
      controller.stub(:find_collection).and_return(@collection = mock_model(Atrium::Collection))
      @showcase = mock_model(Atrium::Showcase)
      @showcases=mock("Mocking showcases", :build => @showcase, :find=>@showcase)
      @showcase.should_receive(:save!).and_return(true)
    end
    context "when creating showcase for exhibit" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@exhibit = mock_model(Atrium::Exhibit))
        @exhibit.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase for exhibit" do
        do_create
        assigns(:parent).should == @exhibit
        assigns(:showcase).should == @showcase
      end

      it "should render edit template" do
        do_create
        response.should render_template("edit")
      end
    end
    context "when creating showcase for collection" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@collection)
        @collection.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase for exhibit" do
        do_create
        assigns(:parent).should == @collection
        assigns(:showcase).should == @showcase
      end

      it "should render new template" do
        do_create
        response.should render_template("edit")
      end
    end
  end

  describe "Get #edit" do
    before(:each) do
      controller.stub(:find_collection).and_return(@collection = mock_model(Atrium::Collection))
      @showcase = mock_model(Atrium::Showcase)
      @showcases=mock("Mocking showcases", :build => @showcase, :find=>@showcase)
    end
    context "when edit showcase of collection" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@collection)
        @collection.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase" do
        do_edit
        assigns(:showcase).should == @showcase
      end

      it "should render edit template" do
        do_edit
        response.should render_template("edit")
      end
    end
    context "when edit showcase of exhibit" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@exhibit = mock_model(Atrium::Exhibit))
        @exhibit.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase" do
        do_edit
        assigns(:showcase).should == @showcase
      end

      it "should render edit template" do
        do_edit
        response.should render_template("edit")
      end
    end
  end

  describe "Put #update" do
    before(:each) do
      controller.stub(:find_collection).and_return(@collection = mock_model(Atrium::Collection))
      @showcase = mock_model(Atrium::Showcase)
      @showcases=mock("Mocking showcases", :build => @showcase, :find=>@showcase)
      @showcase.should_receive(:update_attributes).and_return(true)
    end
    context "when updating showcase of collection" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@collection)
        @collection.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase" do
        do_update
        assigns(:showcase).should == @showcase
      end

      it "should render edit template" do
        do_update
        flash[:notice].should == "Showcase was successfully updated."
        response.should render_template("edit")
      end
    end
    context "when updating showcase of exhibit" do
      before(:each) do
        controller.should_receive(:find_parent).and_return(@exhibit = mock_model(Atrium::Exhibit))
        @exhibit.should_receive(:showcases).and_return(@showcases)
      end
      it "should assign showcase" do
        do_update
        assigns(:showcase).should == @showcase
      end

      it "should render edit template" do
        do_update
        flash[:notice].should == "Showcase was successfully updated."
        response.should render_template("edit")
      end
    end
  end

  describe "Delete #destroy" do
    before(:each) do
      controller.stub(:find_collection).and_return(@collection = mock_model(Atrium::Collection))
      @showcase = mock_model(Atrium::Showcase)
      @showcases=mock("Mocking showcases", :build => @showcase, :find=>@showcase)
    end
    context "when deleting showcase of collection" do
      before(:each) do
        controller.stub(:parent).and_return(@collection)
        @collection.should_receive(:showcases).and_return(@showcases)
      end
      it "destroy exhibit successfully" do
        delete :destroy, { :id => 1 }
        flash[:notice].should == "Showcase 1 was deleted successfully."
      end

      it "redirects to collection edit" do
        delete :destroy, { :id => @showcase.id }
        response.should redirect_to(edit_collection_path(@collection))
      end
    end
    context "when deleting showcase of exhibit" do
      before(:each) do
        controller.stub(:parent).and_return(@exhibit = mock_model(Atrium::Exhibit))
        @exhibit.should_receive(:showcases).and_return(@showcases)
      end
      it "destroy showcase successfully" do
        delete :destroy, { :id => 1 }
        flash[:notice].should == "Showcase 1 was deleted successfully."
      end

      it "redirects to exhibit showcase index" do
        delete :destroy, { :id => @showcase.id }
        response.should redirect_to(exhibit_showcases_path(:exhibit_id=>@exhibit.id))
      end
    end
  end

end
