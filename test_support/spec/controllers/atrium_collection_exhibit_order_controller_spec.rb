require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AtriumCollectionExhibitOrderController do

  describe "Get index" do
    it "should render JSON of session" do
      mock_exhibit = mock("exhibit")
      mock_collection = mock("collection")
      mock_exhibit_order = mock({})
      Atrium::Collection.stubs(:find).with("1").returns(mock_collection)
      mock_collection.expects("exhibit_order").returns(mock_exhibit_order)
      get :index,{ :id=>"1"}
      assigns[:exhibit_order].should == mock_exhibit_order
      #response.body.should == {}.to_json
    end

  end

  describe "Put update" do

  end

end