require 'spec_helper'

describe Atrium::OrderController do

  describe "Get Collection Exhibit order index" do
    it "should render JSON of exhibit order" do
      exhibit_order = {'key' => 'value'}
      controller.stub(:collection).and_return(@collection= mock_model(Atrium::Collection, save:true))
      @collection.should_receive("exhibit_order").and_return(exhibit_order)

      get :exhibit_index,{ :id=>"1", :format=> "json"}

      JSON.parse(response.body).should == exhibit_order
    end
  end


  describe "Get Exhibit facet order index" do
    it "should render JSON of exhibit order" do
      facet_order = {'key' => 'value'}
      controller.stub(:exhibit).and_return(@exhibit= mock_model(Atrium::Exhibit, save:true))
      @exhibit.should_receive("facet_order").and_return(facet_order)

      get :exhibit_facet_index,{ :id=>"1", :format=> "json"}

      JSON.parse(response.body).should == facet_order
    end
  end


  describe "Get Exhibit showcase order index" do
    it "should render JSON of exhibit order" do
      showcase_order = {'key' => 'value'}
      controller.stub(:exhibit).and_return(@exhibit= mock_model(Atrium::Exhibit, save:true))
      @exhibit.should_receive("showcase_order").and_return(showcase_order)

      get :exhibit_showcase_index,{ :id=>"1", :format=> "json"}

      JSON.parse(response.body).should == showcase_order
    end
  end

  describe "Get collection showcase order index" do
    it "should render JSON of showcase order" do
      showcase_order = {'key' => 'value'}
      controller.stub(:collection).and_return(@collection= mock_model(Atrium::Collection, save:true))
      @collection.should_receive("showcase_order").and_return(showcase_order)

      get :collection_showcase_index,{ :id=>"1", :format=> "json"}

      JSON.parse(response.body).should == showcase_order
    end
  end


  describe "Post #update_collection_exhibits_order"   do
    it "should render JSON of exhibit order after updating the exhibit order" do
      controller.stub(:collection).and_return(@collection= mock_model(Atrium::Collection, save:true))
      mock_exhibit_order = {"1"=>"2", "2"=>"3","3"=>"1"}
      @collection.should_receive(:exhibit_order=).and_return(mock_exhibit_order)
      @collection.should_receive("exhibit_order").and_return(mock_exhibit_order)
      post :update_collection_exhibits_order, {collection:{"1"=>"2", "2"=>"3","3"=>"1"},:format=> "json"}
      response.body.should == mock_exhibit_order.to_json
    end
  end

  describe "Post #update_collection_showcases_order"   do
    it "should render JSON of exhibit order after updating the exhibit order" do
      controller.stub(:collection).and_return(@collection= mock_model(Atrium::Collection, save:true))
      mock_showcase_order = {"1"=>"2", "2"=>"3","3"=>"1"}
      @collection.should_receive(:showcase_order=).and_return(mock_showcase_order)
      @collection.should_receive("showcase_order").and_return(mock_showcase_order)
      post :update_collection_showcases_order, {collection:{"1"=>"2", "2"=>"3","3"=>"1"},:format=> "json"}
      response.body.should == mock_showcase_order.to_json
    end
  end

  describe "Post #update_exhibit_showcases_order"   do
    it "should render JSON of exhibit order after updating the exhibit order" do
      controller.stub(:exhibit).and_return(@exhibit= mock_model(Atrium::Exhibit, save:true))
      mock_showcase_order = {"1"=>"2", "2"=>"3","3"=>"1"}
      @exhibit.should_receive(:showcase_order=).and_return(mock_showcase_order)
      @exhibit.should_receive("showcase_order").and_return(mock_showcase_order)
      post :update_exhibit_showcases_order, {collection:{"1"=>"2", "2"=>"3","3"=>"1"},:format=> "json"}
      response.body.should == mock_showcase_order.to_json
    end
  end

  describe "Post #update_exhibit_facets_order"   do
    it "should render JSON of exhibit order after updating the exhibit order" do
      controller.stub(:exhibit).and_return(@exhibit= mock_model(Atrium::Exhibit, save:true))
      mock_facet_order = {"1"=>"2", "2"=>"3","3"=>"1"}
      @exhibit.should_receive(:facet_order=).and_return(mock_facet_order)
      @exhibit.should_receive("facet_order").and_return(mock_facet_order)
      post :update_exhibit_facets_order, {collection:{"1"=>"2", "2"=>"3","3"=>"1"},:format=> "json"}
      response.body.should == mock_facet_order.to_json
    end
  end

end