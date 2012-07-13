require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::ShowcasesController do
   before do
     @collection = mock("atrium_collection")
     controller.stubs(:initialize_collection).returns(@collection)
     controller.stubs(:current_layout).returns("atrium")
   end

  describe '#determine_collection_id' do
    #before do
    #  @description = Atrium::Description.new(:atrium_showcase_id=>@collection_showcase.id)
    #  @description.save
    #  @collection_showcase.stub(:parent).returns(@collection)
    #end
    it 'should return collection id of collection showcase from params ' do
      collection = Atrium::Collection.new
      collection.save
      showcase = Atrium::Showcase.new(:showcases_id=> collection.id, :showcases_type=>collection.class.name)
      showcase.save
      Atrium::Showcase.stubs(:find).with("1").returns(showcase)
      controller.params[:id] = '1'
      collection_id=controller.send(:determine_collection_id)
      collection_id.should == 1
    end

    it 'should return collection id of exhibit showcase from params ' do
      collection = Atrium::Collection.new
      collection.save
      exhibit = Atrium::Exhibit.new(:atrium_collection_id=> collection.id, :set_number=>1)
      exhibit.save
      showcase = Atrium::Showcase.new(:showcases_id=> exhibit.id, :showcases_type=>exhibit.class.name)
      showcase.save
      Atrium::Showcase.stubs(:find).with("1").returns(showcase)
      showcase.stubs(:parent).returns(exhibit)
      #showcase.should_receive(:parent).and_return(exhibit)
      controller.params[:id] = '1'
      collection_id=controller.send(:determine_collection_id)
      collection_id.should == 1
    end

    it 'return nil if exhibit id not available in params' do
      collection_id=controller.send(:determine_collection_id)
      collection_id.should == nil
    end
  end

  describe "Get New"   do
    before do
      @collection = mock("atrium_collection")
      @exhibit = mock("atrium_exhibit")
      @showcase = mock("atrium_showcase")
      @showcase.stubs(:showcases_id).returns(1)
      @showcase.stubs(:build).returns(@showcase)
      @showcase.stubs(:showcases_id).returns(1)
      Atrium::Collection.stubs(:find_by_id).returns(@collection)
      Atrium::Exhibit.stubs(:find_by_id).returns(@exhibit)
    end
    it "create showcase for collection" do
      Atrium::Showcase.expects(:with_selected_facets).returns([])
      @collection.expects(:showcases).returns(@showcase)
      @showcase.stubs(:for_exhibit?).returns(false)
      @showcase.expects(:save!)
      xhr :get, :new, {:collection_id => 1}
      session[:edit_showcase].should == true
      response.should redirect_to atrium_collection_showcase_path(1,@showcase.id)
    end
    it "create showcase for exhibit" do
      Atrium::Showcase.expects(:with_selected_facets).returns([])
      @showcase.stubs(:for_exhibit?).returns(true)
      @exhibit.expects(:showcases).returns(@showcase)
      @showcase.expects(:save!)
      xhr :get, :new, {:exhibit_id => 1}
      session[:edit_showcase].should == true
      response.should redirect_to atrium_exhibit_path(1)
    end
    it "return existing showcase for collection" do
      Atrium::Showcase.expects(:with_selected_facets).returns([@showcase])
      @showcase.expects(:for_exhibit?).returns(false)
      xhr :get, :new, {:collection_id => 1}
      assigns[:atrium_showcase].should == @showcase
    end
    it "show redirect to collection page" do
      Atrium::Showcase.expects(:with_selected_facets).returns([@showcase])
      @showcase.expects(:for_exhibit?).returns(false)
      xhr :get, :new, {:collection_id => 1}
      session[:edit_showcase].should == true
      response.should redirect_to atrium_collection_showcase_path(1,@showcase.id)
    end
  end


  describe "Get Show"  do
    it "should assign showcase to mocked showcase" do
      session[:folder_document_ids]=nil
      @showcase = mock("atrium_showcase")
      Atrium::Showcase.stubs(:find).returns(@showcase)
      @showcase.stubs(:showcase_items=).returns({})
      @showcase.stubs(:showcase_items).returns({})
      @showcase.expects(:save)
      get :show, {:id=>1}
      assigns[:atrium_showcase].should == @showcase
    end
    it "redirect to show view when featured items are not selected" do
      session[:folder_document_ids]=nil
      @showcase = mock("atrium_showcase")
      Atrium::Showcase.stubs(:find).returns(@showcase)
      @showcase.stubs(:showcase_items=).returns({})
      @showcase.stubs(:showcase_items).returns({})
      @showcase.expects(:save)
      get :show, {:id=>1}
      response.should render_template 'layouts/atrium'
      response.should render_template("show")
    end
    it "should not assign layout when params is passed" do
      session[:folder_document_ids]=nil
      @showcase = mock("atrium_showcase")
      @showcase.stubs(:showcase_items=).returns({})
      @showcase.stubs(:showcase_items).returns({})
      @showcase.expects(:save)
      Atrium::Showcase.stubs(:find).returns(@showcase)
      get :show, { :id => "1", :no_layout=>true }
      response.should_not render_template 'layouts/atrium'
      response.should render_template("show")
    end

    it "save session documents to showcase showcase_items" do
      @showcase = Atrium::Showcase.new({:showcases_id=>1, :showcases_type=>"Atrium::Collection"})
      @showcase.save!
      Atrium::Showcase.stubs(:find).returns(@showcase)
      #@showcase.expects(:save)
      session[:folder_document_ids]=["1", "2", "3"]
      get :show, { :id => 1, :no_layout=>true }
      assigns[:atrium_showcase].should == @showcase
      response.should_not render_template 'layouts/atrium'
      response.should render_template("show")
    end
  end

  describe "Post remove_featured"  do
    it "should assign showcase to mocked showcase" do
      session[:folder_document_ids]=nil
      @showcase = mock("atrium_showcase")
      Atrium::Showcase.stubs(:find).returns(@showcase)
      @showcase.stubs(:showcase_items=).returns({})
      @showcase.stubs(:showcase_items).returns({})
      @showcase.expects(:save)
      post :remove_featured, {:id=>1}
      assigns[:atrium_showcase].should == @showcase
    end
    it "remove given featured solr doc ide from showcase item" do
      @showcase = mock("atrium_showcase")
      Atrium::Showcase.stubs(:find).returns(@showcase)
      @showcase.stubs(:showcase_items=).returns({:type=>"featured", :solr_doc_ids=>"1,2,3"})
      @showcase.stubs(:showcase_items).returns({:type=>"featured", :solr_doc_ids=>"1,2,3"})
      @showcase.expects(:save)
      post :remove_featured, {:id=>1, :solr_doc_id=>"1"}
      assigns[:featured_items].should == ["2", "3"]
    end

    it "save session documents to showcase showcase_items" do
      @showcase = Atrium::Showcase.new({:showcases_id=>1, :showcases_type=>"Atrium::Collection"})
      @showcase.save!
      Atrium::Showcase.stubs(:find).returns(@showcase)
      #@showcase.expects(:save)
      session[:folder_document_ids]=["1", "2", "3"]
      get :show, { :id => 1, :no_layout=>true }
      assigns[:atrium_showcase].should == @showcase
      response.should_not render_template 'layouts/atrium'
      response.should render_template("show")
    end
  end

  describe "Get featured" do
    before do
      session[:folder_document_ids]=nil
      @showcase = mock("atrium_showcase")
      Atrium::Showcase.stubs(:find).with("1").returns(@showcase)
    end

    it "set session documents to showcase featured items  solr documents if present" do
      @showcase.stubs(:showcase_items).returns(nil)
      @showcase.stubs(:parent).returns(nil)
      get :featured, {:id => "1"}
      response.should redirect_to(catalog_index_path(:add_featured=>true, :search_field=>"all_fields"))
    end

    it "set session documents to exhibit filter query params  solr documents if present" do
      @showcase.stubs(:showcase_items).returns({:solr_doc_ids=>"1,2,3"})
      @showcase.stubs(:parent).returns(nil)
      get :featured, {:id => "1"}
      session[:folder_document_ids] == ["1", "2", "3"]
    end
  end

  describe "Get refresh_showcase" do
    before do
      @showcase = mock("atrium_showcase")
     Atrium::Showcase.stubs(:find).returns(@showcase)
    end
    it "should return collection path for collection showcase" do
      @showcase.expects(:showcases_id).returns(1)
      @showcase.stubs(:for_exhibit?).returns(false)
      get :refresh_showcase, {:id=>1}
      assigns[:atrium_showcase].should == @showcase
      session[:edit_showcase].should be_nil
      response.should redirect_to atrium_collection_path(1)
    end
    it "should return exhibit path for exhibit showcase" do
      @showcase.expects(:showcases_id).returns(1)
      @showcase.stubs(:for_exhibit?).returns(true)
      get :refresh_showcase, {:id=>1, :f=>{"continent"=>["North America"]}}
      assigns[:atrium_showcase].should == @showcase
      session[:edit_showcase].should be_nil
      response.should redirect_to atrium_exhibit_path(1, :f=>{"continent"=>["North America"]})
    end
  end

end
