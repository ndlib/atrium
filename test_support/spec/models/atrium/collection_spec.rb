require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::Collection do
  it { should have_many :showcases }
  it { should have_many :search_facets }
  it { should have_many :exhibits }

  describe "#theme_path" do
    it 'should default to "atrium_themes/default"' do
      subject.theme_path.should == "atrium_themes/default"
    end
    it 'should be updatable' do
      theme_name = 'chunky_bacon'
      subject.theme = theme_name
      subject.theme_path.should == "atrium_themes/#{theme_name}"
    end
  end

  describe "#display_title" do
    it "should default to 'Unnamed Collection'" do
      subject.display_title.should == "<h2>#{subject.pretty_title}</h2>"
    end

    it "should use #title_markup when set" do
      string = '<h2>Saving <em>the World</em></h2>'
      subject.title_markup = string
      subject.display_title.should == string
    end
  end
end
