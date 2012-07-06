require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::DescriptionsController do
   before do
      #Atrium::Description.stubs(:new).returns(@atrium_description)
      @collection = Atrium::Collection.new
      @collection.save
      @collection_showcase = Atrium::Showcase.new(:showcases_id=>@collection.id, :showcases_type=>@collection.class.name)
      @collection_showcase.save
      controller.stubs(:initialize_collection).returns(@collection)
      controller.stubs(:get_exhibit_navigation_data).returns([])
   end

  describe "Get index" do
    it "returns list of descriptions for given showcase" do
      get :index, {:showcase_id => @collection_showcase.id}
      response.should render_template 'layouts/atrium'
      response.should render_template("index")
    end
    it "returns list of descriptions for given showcase without layout" do
      get :index, {:showcase_id => @collection_showcase.id, :no_layout=>true}
      puts "Res: #{response.body.inspect}"
      response.should render_template("index")
    end
  end

  describe "Get New"   do
    it "build new description form" do
      get :new, {:showcase_id => @collection_showcase.id}
      response.should render_template 'layouts/atrium'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    let(:@atrium_description) { mock_model(Atrium::Description) }
    it "sets a flash[:notice] message" do
      post :create, {:showcase_id => @collection_showcase.id,:atrium_description =>{:atrium_showcase_id => @collection_showcase.id}}
      flash[:notice].should eq('Description was successfully created.')
    end
    it "redirects to the edit page" do
      post :create, {:showcase_id => @collection_showcase.id,:atrium_description =>{:atrium_showcase_id => @collection_showcase.id}}
      response.code.should == "302"
      response.should redirect_to(edit_atrium_description_path(:id=>1))
    end
    it "create fails if showcase id not passed" do
      threw_exception = false
      begin
        post :create
      rescue
        threw_exception = true
      end
      threw_exception.should == true
    end
  end

  describe "Get Edit"  do
    before do
      @description = mock()
      @essay=mock()
      @summary=mock()
      Atrium::Description.stubs(:find).with("1").returns(@description)
      @description.expects(:essay).returns(nil)
      @description.expects(:summary).returns(nil)
      @description.stubs(:build_essay).with(:content_type=>"essay").returns(@essay)
      @description.stubs(:build_summary).with(:content_type=>"summary").returns(@summary)
    end
    it "returns description of the given description id" do
      get :edit, { :id => "1" }
      assigns[:atrium_description].should == @description
    end
    it "build description form for given description id" do
      get :edit, { :id => "1" }
      response.should render_template 'layouts/atrium'
      response.should render_template("edit")
    end
  end

  describe "Put Update" do
    before do
      @description = mock()
      Atrium::Description.stubs(:find).with("1").returns(@description)
      @description.stubs(:update_attributes).returns(true)
      @description.expects(:essay).returns(nil)
    end
    it "sets a flash[:notice] message" do
      put :update, {:id => "1", :atrium_description =>{:atrium_showcase_id => @collection_showcase.id}}
      flash[:notice].should eq('Description was successfully updated.')
    end
  end

  describe "Get Show"  do
    before do
      @description = mock()
      Atrium::Description.stubs(:find).with("1").returns(@description)
      @description.expects(:description_solr_id).returns(nil)
    end
    it "returns description of the given description id" do
      get :show, { :id => "1" }
      response.should render_template 'layouts/atrium'
      response.should render_template("show")
    end

  end

  describe "Delete" do
    before do
     @description = mock()
     Atrium::Description.stubs(:find).with("1").returns(@description)
    end
    it "returns description of the given description id" do
      Atrium::Description.expects(:destroy).with("1").returns(true)
      delete :destroy, { :id => "1" }
      response.body.should == "Description 1 was deleted successfully."
    end

  end

  describe "atrium_descriptions_add"


  describe "atrium_descriptions_link"

end