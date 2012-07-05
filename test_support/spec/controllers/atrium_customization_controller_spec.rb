require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AtriumCustomizationController do

  describe "Get start" do
    before do
      session[:edit_showcase]=true
    end

    it "should render html response" do
      xhr :get, :start, :type=>"collection", :id=>"1"
      response.should redirect_to(atrium_collection_path(:id=>1))
    end

    it "should render JSON of session" do
      xhr :get, :start, :format=>"json"
      response.body.should == session[:edit_showcase].to_json
    end

  end

  describe "Get stop" do
     before do
      session[:edit_showcase]=nil
    end
     it "should render html response" do
      xhr :get, :stop, :type=>"collection", :id=>"1"
      response.should redirect_to(atrium_collection_path(:id=>1))
    end

    it "should render JSON of session" do
      xhr :get, :stop, :format=>"json"
      response.body.should == session[:edit_showcase].to_json
    end

  end

end