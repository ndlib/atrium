require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AtriumCollectionExhibitOrderController do

  describe "Get index" do
    it "returns exhibit order" do
      mock_collection = mock("collection")
      mock_exhibit_order = mock({})
      Atrium::Collection.stubs(:find).with("1").returns(mock_collection)
      mock_collection.expects("exhibit_order").returns(mock_exhibit_order)
      get :index,{ :id=>"1"}
      assigns[:exhibit_order].should == mock_exhibit_order
    end

    it "should render JSON of session" do
      mock_collection = mock("collection")
      Atrium::Collection.stubs(:find).with("1").returns(mock_collection)
      mock_collection.expects("exhibit_order").returns({})
      get :index,{ :id=>"1", :format=> "json"}
      response.body.should == {}.to_json
    end
  end

  describe "Post update" do
    it "should render JSON of exhibit order after updating the exhibit order" do
      mock_collection = mock("collection")
      mock_exhibit_order = {"1"=>"2", "2"=>"3","3"=>"1"}
      Atrium::Collection.stubs(:find).with("1").returns(mock_collection)
      mock_collection.expects(:exhibit_order=).with({"3"=>"1", "2"=>"3", "1"=>"2"}).returns(mock_exhibit_order)
      mock_collection.expects("exhibit_order").returns(mock_exhibit_order)
      post :update,{ :id=>"1", :collection =>{"1"=>"2", "2"=>"3", "3"=>"1"}, :format=> "json"}
      response.body.should == mock_exhibit_order.to_json
    end
  end

end