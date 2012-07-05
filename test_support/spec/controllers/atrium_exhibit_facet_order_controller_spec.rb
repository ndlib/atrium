require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AtriumExhibitFacetOrderController do

  describe "Get index" do
    it "returns facet order" do
      mock_exhibit = mock("exhibit")
      mock_facet_order = mock({})
      Atrium::Exhibit.stubs(:find).with("1").returns(mock_exhibit)
      mock_exhibit.expects("facet_order").returns(mock_facet_order)
      get :index,{ :id=>"1"}
      assigns[:facet_order].should == mock_facet_order
    end

    it "should render JSON of session" do
      mock_exhibit = mock("exhibit")
      Atrium::Exhibit.stubs(:find).with("1").returns(mock_exhibit)
      mock_exhibit.expects("facet_order").returns({})
      get :index,{ :id=>"1", :format=> "json"}
      response.body.should == {}.to_json
    end
  end

  describe "Post update" do
    it "should render JSON of facet order after updating the facet order" do
      mock_exhibit = mock("exhibit")
      mock_facet_order = {"1"=>"2", "2"=>"3","3"=>"1"}
      Atrium::Exhibit.stubs(:find).with("1").returns(mock_exhibit)
      mock_exhibit.expects(:facet_order=).with({"3"=>"1", "2"=>"3", "1"=>"2"}).returns(mock_facet_order)
      mock_exhibit.expects("facet_order").returns(mock_facet_order)
      post :update,{ :id=>"1", :collection =>{"1"=>"2", "2"=>"3", "3"=>"1"}, :format=> "json"}
      response.body.should == mock_facet_order.to_json
    end
  end

end