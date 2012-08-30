require 'spec_helper'

describe Atrium::Collection do
  Given(:collection_attributes) { {} }
  Given(:collection) { Atrium::Collection.new(collection_attributes) }
  it { should have_many :showcases }
  it { should have_many :search_facets }
  it { should have_many :exhibits }

  context "#saved_search_id=" do
    before(:each) do
      Atrium.saved_search_class = 'Object'
    end
    after(:each) do
      Atrium.saved_search_class = nil
    end
    Given(:saved_search_id) { 1 }
    Given(:filter_query_params) { {f: [1,2,3], q: ['a','b'] }}
    Given(:saved_search) { mock(query_params: filter_query_params) }

    context 'save_search_id is not present' do
      Given(:saved_search_id) { nil }
      When { collection.filter_query_params = filter_query_params }
      Then {
        lambda {
          collection.saved_search_id = nil
        }.should_not change(collection, :filter_query_params)
      }
    end
    context 'saved search is found' do
      When {
        Atrium.saved_search_class.
        should_receive(:find).
        with(saved_search_id).
        and_return(saved_search)
      }
      Then('#filter_query_params is set') {
        collection.filter_query_params.should == {}
        collection.saved_search_id.should == nil

        collection.saved_search_id = saved_search_id

        collection.saved_search_id.should == saved_search_id
        collection.filter_query_params.should == filter_query_params
      }
    end
    context 'saved search is not found' do
      When {
        Atrium.saved_search_class.
        should_receive(:find).
        with(saved_search_id).
        and_raise(ActiveRecord::RecordNotFound)
      }
      Then('#filter_query_params remains empty') {
        collection.filter_query_params.should == {}
        collection.saved_search_id.should == nil

        collection.saved_search_id = saved_search_id

        collection.filter_query_params.should == {}
        collection.saved_search_id.should == nil
      }
    end
  end

  context "#url_slug" do
    context 'calculated from title' do
      Given(:collection_attributes) { { url_slug: 'Hello World' } }
      When { collection.save }
      Then { collection.url_slug.should == 'hello-world' }
    end
  end
  context "#theme_path" do
    context 'default value' do
      Then { collection.theme_path.should == "atrium_themes/default" }
    end
    context 'set value' do
      Given(:theme_name) { 'chunky_bacon' }
      When { collection.theme = theme_name }
      Then { collection.theme_path.should == "atrium_themes/#{theme_name}" }
    end
  end

  context "#display_title" do
    context 'default value' do
      Then {collection.display_title.should == "<h2>#{collection.pretty_title}</h2>" }
    end
    context 'set value' do
      Given(:title_markup_to_use) { '<h2>Saving <em>the World</em></h2>' }
      When { collection.title_markup = title_markup_to_use }
      Then { collection.display_title.should == title_markup_to_use }
    end
  end
end
