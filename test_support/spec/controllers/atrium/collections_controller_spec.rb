require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::CollectionsController do
   before do
     @collection = mock("atrium_collection")
     Atrium::Collection.stubs(:find).with("1").returns(@collection)
     controller.stubs(:initialize_collection).returns(@collection)
     controller.stubs(:current_layout).returns("atrium")
   end

  describe "Get New"   do
    it "build new collection form" do
      get :new
      response.should redirect_to(edit_atrium_collection_path(:id=>1))
    end
  end

  describe "POST create" do
    it "redirects to the edit page" do
      post :create
      response.code.should == "302"
      response.should redirect_to(edit_atrium_collection_path(:id=>1))
    end
  end

  #describe "Get home_page_text_config"  do
  #  it "home_page_text_config" do
  #    get :home_page_text_config, { :id => "1" }
  #    pending
  #  end
  #end

  describe "Get Set Collection Scope" do
    before do
      session[:folder_document_ids]=[]
    end

    it "set session documents to exhibit filter query params  solr documents if present" do
      @collection.stubs(:filter_query_params).returns(nil)
      get :set_collection_scope, {:id => "1"}
      response.should redirect_to(catalog_index_path)
    end

    it "set session documents to exhibit filter query params  solr documents if present" do
      @collection.stubs(:filter_query_params).returns({:solr_doc_ids=>"1,2,3"})
      get :set_collection_scope, {:id => "1"}
      session[:folder_document_ids] == ["1", "2", "3"]
    end
  end


  describe "Get Unset Collection Scope" do
    before do
      session[:folder_document_ids]=[]
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:new).returns(@exhibit)
      @collection.expects(:update_attributes).returns(true)
    end

    it "sets a flash[:notice] after removing scope of the collection" do
      get :unset_collection_scope, {:id => "1"}
      flash[:notice].should eq('Collection scope removed successfully')
    end

    it "redirects to the edit page" do
      put :unset_collection_scope, {:id => "1"}
      response.code.should == "200"
      response.should render_template("edit")
    end
  end

  describe "Get Edit"  do
    before do
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:new).returns(@exhibit)
    end
    it "build collection form for given collection id" do
      get :edit, { :id => "1" }
      response.should render_template 'layouts/atrium'
      response.should render_template("edit")
    end
  end

  describe "Put Update" do
    before do
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:new).returns(@exhibit)
      controller.stubs(:get_exhibit_navigation_data).returns([])

    end
    it "sets a flash[:notice] after successful update" do
      @collection.expects(:update_attributes).returns(true)
      put :update, {:id => "1", :atrium_collection =>{:title => "testing collection controller"}}
      flash[:notice].should eq('Collection was successfully updated.')
    end

    it "redirects to the edit page" do
      @collection.expects(:update_attributes).returns(true)
      put :update, {:id => "1", :atrium_collection =>{:title => "testing collection controller"}}
      response.code.should == "200"
      response.should render_template("edit")
    end

    it "redirects to the edit page with error message" do
      @collection.expects(:update_attributes).returns(false)
      put :update, {:id => "1", :atrium_collection =>{:title => "testing collection controller"}}
      flash[:notice].should_not eq('Collection was successfully updated.')
      response.should render_template("edit")
    end
  end
  #
  #describe "Get Show"  do
  #  before do
  #    @exhibit = mock("atrium_exhibit")
  #    Atrium::Exhibit.stubs(:find).with("1").returns(@exhibit)
  #    controller.stubs(:get_all_children).returns([])
  #    controller.stubs(:get_exhibit_navigation_data).returns([])
  #    @exhibit.expects(:filter_query_params).returns(nil)
  #  end
  #  it "returns exhibit of the given exhibit id with template" do
  #    Atrium::Showcase.expects(:with_selected_facets).returns([])
  #    get :show, { :id => "1" }
  #    response.should render_template 'layouts/atrium'
  #    response.should render_template("show")
  #  end
  #
  #  it "returns exhibit of the given exhibit id without template" do
  #    Atrium::Showcase.expects(:with_selected_facets).returns([])
  #    get :show, { :id => "1", :no_layout=>true }
  #    response.should_not render_template 'layouts/atrium'
  #    response.should render_template("show")
  #  end
  #
  #  it "should return only items that are through exhibit scope filter" do
  #    pending
  #  end
  #
  #  it "should return any featured item added through showcase" do
  #    pending
  #  end
  #
  #  it "should return any descriptions added through showcase" do
  #    pending
  #  end
  #end
  #
  #
  #
  describe "Delete" do
    before do
     @exhibit = mock("atrium_exhibit")
     Atrium::Exhibit.stubs(:new).returns(@exhibit)
     @collection.expects(:destroy).returns(true)
    end
    it "destroy exhibit successfully" do
      delete :destroy, { :id => "1" }
      flash[:notice].should == "Collection deleted."
    end

    it "redirects to catalog index" do
      delete :destroy, { :id => "1" }
      response.should redirect_to(catalog_index_path)
    end

  end
end
