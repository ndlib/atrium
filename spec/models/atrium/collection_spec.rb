require 'spec_helper'

describe Atrium::Collection do
  subject { Atrium::Collection.new(collection_attributes) }
  Given(:collection_attributes) { {} }
  it { should have_many :showcases }
  it { should have_many :search_facets }
  it { should have_many :exhibits }

  it_behaves_like "query_param_mixin"

  context "#url_slug" do
    context 'calculated from title' do
      Given(:collection_attributes) { { url_slug: 'Hello World' } }
      When { subject.save }
      Then { subject.url_slug.should == 'hello-world' }
    end
  end
  context "#theme_path" do
    context 'default value' do
      Then { subject.theme_path.should == "atrium_themes/default" }
    end
    context 'set value' do
      Given(:theme_name) { 'chunky_bacon' }
      When { subject.theme = theme_name }
      Then { subject.theme_path.should == "atrium_themes/#{theme_name}" }
    end
  end

  context "#display_title" do
    context 'default value' do
      Then {subject.display_title.should == "<h2>#{subject.pretty_title}</h2>" }
    end
    context 'set value' do
      Given(:title_markup_to_use) { '<h2>Saving <em>the World</em></h2>' }
      When { subject.title_markup = title_markup_to_use }
      Then { subject.display_title.should == title_markup_to_use }
    end
  end
end
