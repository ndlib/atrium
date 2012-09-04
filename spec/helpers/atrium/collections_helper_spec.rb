require 'spec_helper'
describe Atrium::CollectionsHelper do

  describe "saved_searches_for_select" do
    let(:current_user) { 'test' }
    let(:saved_search){
      {
        id: 1,
        query_params: {
          q: "query",
          sort: "sort",
          per_page: "20",
          f: {"field" => ["value1", "value2"], "other_field" => ['asdf']},
          controller: "catalog",
          action: "index",
          commit: "search"
        }
      }
    }
    it "should retrieve facet saved search from blacklight" do
      helper.stub :current_user => current_user
      Atrium.should_receive(:saved_searches_for).
        with(current_user).
        and_return([saved_search])
      actual_search = helper.saved_searches_for_select.first

      actual_search.first.should == {
        q: saved_search[:query_params][:q],
        f: saved_search[:query_params][:f]
      }.inspect
      actual_search.last.should == saved_search[:id]
    end
  end

  describe "get_saved_items" do
    let(:current_user) { 'test' }
    it "should retrieve facet saved search from blacklight" do
      saved_item1=mock(:document_id => 123, :title=> "my title")
      saved_item2=mock(:document_id => 456, :title=> "new title")
      helper.stub :current_user => current_user
      Atrium.stub(:saved_items_for).with(current_user).and_return([saved_item1, saved_item2])
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
