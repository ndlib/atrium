require 'spec_helper'
describe Atrium::CollectionsHelper do

   describe "get_saved_search" do
     let(:atrium_user) { 'test' }
     let(:search){{:q => "query", :sort => "sort", :per_page => "20", :f => {"field" => ["value1", "value2"], "other_field" => ['asdf']}, :controller => "catalog", :action => "index", :commit => "search"}}
     it "should retrieve facet saved search from blacklight" do
       saved_search=mock(:query_params => search)
       helper.stub :atrium_user => atrium_user
       Atrium.stub(:saved_searches_for).with(atrium_user).and_return([saved_search])
       saved_search_result=helper.get_saved_search.first

       saved_search_result.should have_key(:f)
       saved_search_result.should have_key(:q)

       saved_search_result.should_not have_key(:sort)
       saved_search_result.should_not have_key(:controller)
       saved_search_result.should_not have_key(:per_page)
       saved_search_result.should_not have_key(:action)
       saved_search_result.should_not have_key(:commit)

       saved_search_result[:f].should == {"field" => ["value1", "value2"], "other_field" => ['asdf']}
       saved_search_result[:q].should == "query"

     end
   end

   describe "get_saved_items" do
     let(:atrium_user) { 'test' }
     it "should retrieve facet saved search from blacklight" do
       saved_item1=mock(:document_id => 123, :title=> "my title")
       saved_item2=mock(:document_id => 456, :title=> "new title")
       helper.stub :atrium_user => atrium_user
       Atrium.stub(:saved_items_for).with(atrium_user).and_return([saved_item1, saved_item2])
       saved_items_result=helper.get_saved_items

       puts saved_items_result.inspect

       saved_items_result.length.should == 2
       saved_items_result.each do |hash|
         hash.should have_key(:title)
         hash.should have_key(:id)
       end
       saved_items_result[0][:id].should == 123
       saved_items_result[0][:title].should == "my title"

       saved_items_result[1][:id].should == 456
       saved_items_result[1][:title].should == "new title"

     end
   end
end
