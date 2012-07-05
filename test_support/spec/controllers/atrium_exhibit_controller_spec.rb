require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AtriumExhibitsController do
   before do
     @collection = mock("atrium_collection")
     controller.stubs(:initialize_collection).returns(@collection)
     controller.stubs(:current_layout).returns("atrium")
   end

  describe "Get New"   do
    it "build new exhibit form" do
      get :new
      response.should render_template 'layouts/atrium'
      response.should render_template("new")
    end
  end

  describe "POST create" do
    it "sets a flash[:notice] exhibit" do
      post :create, {:atrium_exhibit =>{:atrium_collection_id => 1, :set_number=>1}}
      flash[:notice].should eq('Exhibit was successfully created.')
    end
    it "redirects to the edit page" do
      post :create, {:atrium_exhibit =>{:atrium_collection_id => 1, :set_number=>1}}
      response.code.should == "302"
      response.should redirect_to(edit_atrium_collection_path(:id=>1))
    end
    it "create fails if collection id not passed" do
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
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:find).with("1").returns(@exhibit)
      @exhibit.expects(:collection).returns(@collection)
      controller.stubs(:get_exhibit_navigation_data).returns([])
    end
    it "returns exhibit of the given exhibit id" do
      get :edit, { :id => "1" }
      assigns[:exhibit].should == @exhibit
    end
    it "build exhibit form for given exhibit id" do
      get :edit, { :id => "1" }
      response.should render_template 'layouts/atrium'
      response.should render_template("edit")
    end
  end

  describe "Put Update" do
    before do
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:find).with("1").returns(@exhibit)
      @exhibit.expects(:update_attributes).returns(true)
    end
    it "sets a flash[:notice] after successful update" do
      put :update, {:id => "1", :atrium_exhibit =>{:atrium_collection_id => 1, :set_number=>1}}
      flash[:notice].should eq('Exhibit was successfully updated.')
    end

    it "redirects to the edit page" do
      put :update, {:id => "1", :atrium_exhibit =>{:atrium_collection_id => 1, :set_number=>1}}
      response.code.should == "302"
      response.should redirect_to(edit_atrium_exhibit_path(:id=>1))
    end
  end

  describe "Get Show"  do
    before do
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:find).with("1").returns(@exhibit)
      controller.stubs(:get_all_children).returns([])
      controller.stubs(:get_exhibit_navigation_data).returns([])
      @exhibit.expects(:filter_query_params).returns(nil)
    end
    it "returns exhibit of the given exhibit id with template" do
      Atrium::Showcase.expects(:with_selected_facets).returns([])
      get :show, { :id => "1" }
      response.should render_template 'layouts/atrium'
      response.should render_template("show")
    end

    it "returns exhibit of the given exhibit id without template" do
      Atrium::Showcase.expects(:with_selected_facets).returns([])
      get :show, { :id => "1", :no_layout=>true }
      response.should_not render_template 'layouts/atrium'
      response.should render_template("show")
    end

    it "should return only items that are through exhibit scope filter" do
      pending
    end

    it "should return any featured item added through showcase" do
      pending
    end

    it "should return any descriptions added through showcase" do
      pending
    end
  end

  describe "Get Set Exhibit Scope" do
    before do
      session[:folder_document_ids]=[]
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:find).with("1").returns(@exhibit)
    end

    it "set session documents to exhibit filter query params  solr documents if present" do
      @exhibit.stubs(:filter_query_params).returns(nil)
      get :set_exhibit_scope, {:id => "1"}
      response.should redirect_to(catalog_index_path)
    end

    it "set session documents to exhibit filter query params  solr documents if present" do
      @exhibit.stubs(:filter_query_params).returns({:solr_doc_ids=>"1,2,3"})
      get :set_exhibit_scope, {:id => "1"}
      session[:folder_document_ids] == ["1", "2", "3"]
    end
  end


  describe "Get Unset Exhibit Scope" do
    before do
      session[:folder_document_ids]=[]
      @exhibit = mock("atrium_exhibit")
      Atrium::Exhibit.stubs(:find).with("1").returns(@exhibit)
      @exhibit.expects(:update_attributes).returns(true)
    end

    it "sets a flash[:notice] after removing scope of the exhibit update" do
      get :unset_exhibit_scope, {:id => "1"}
      flash[:notice].should eq('Exhibit scope removed successfully')
    end

    it "redirects to the edit page" do
      put :unset_exhibit_scope, {:id => "1"}
      response.code.should == "200"
      response.should render_template("edit")
    end
  end

  describe "Delete" do
    before do
     @exhibit = mock("atrium_exhibit")
     Atrium::Exhibit.stubs(:find).with("1").returns(@exhibit)
     Atrium::Exhibit.expects(:destroy).with("1").returns(true)
     @exhibit.expects(:atrium_collection_id).returns(1)
    end
    it "destroy exhibit successfully" do
      delete :destroy, { :id => "1" }
      flash[:notice].should == "Exhibit 1 was deleted successfully."
    end

    it "redirects to collection edit page" do
      delete :destroy, { :id => "1" }
      response.should redirect_to(edit_atrium_collection_path(:id=>1))
    end

  end
end
