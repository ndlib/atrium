
require File.expand_path(File.dirname(__FILE__) + '../../../spec_helper')

describe Atrium::Description do
  Given(:description) { Atrium::Description.new() }
  it { should belong_to :showcase }
  it { should have_one :essay }
  it { should have_one :summary }

  it { should be_accessible :description_solr_id }
  it { should be_accessible :page_display }
  it { should be_accessible :title }
  it { should be_accessible :atrium_showcase_id }
  it { should be_accessible :essay_attributes }
  it { should be_accessible :summary_attributes }

  context "#page_display?" do
    context 'default value' do
      Then { description.page_display.should == nil }
    end
    context 'set value' do
      Given(:page_display) { 'test' }
      When { description.page_display = page_display }
      Then { description.page_display.should == "test" }
    end
  end

  context "#show_on_this_page?" do
    context 'default value' do
      Then { description.show_on_this_page?.should == true }
    end
    context 'set value' do
      Given(:page_display) { 'newpage' }
      When { description.page_display = page_display }
      Then { description.show_on_this_page?.should == false }
    end
  end

  context "#pretty title" do
    context 'default value' do
      When { description.id = 1 }
      Then {description.pretty_title.should == "Description 1" }
    end
    context 'set value' do
      Given(:title) { 'Hello World' }
      When { description.title = title }
      Then { description.pretty_title.should == title }
    end
  end
end
