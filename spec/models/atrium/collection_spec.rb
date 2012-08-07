require 'spec_helper'

describe Atrium::Collection do
    Given(:collection) { Atrium::Collection.new() }
    it { should have_many :showcases }
    it { should have_many :search_facets }
    it { should have_many :exhibits }

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
