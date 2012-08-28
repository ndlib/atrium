
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Atrium do

  context "Search Class exists or not" do
    Given(:config) {  lambda {Atrium.saved_search_class} }
    context 'saved_search_class not set in application' do
      Then { config.should raise_error(Atrium::ConfigurationNotSet) }
    end
    context 'saved_search_class set in application' do
      When {Atrium.saved_search_class = "SavedSearch"}
      Then { config.should_not raise_error(Atrium::ConfigurationNotSet)}
    end
  end

  context "atrium config settings" do
    context 'default value' do
      Then { Atrium.config.should eq(Atrium.facet_config) }
    end
    context 'set value' do
      Given(:value) { 'this is overridden facet config' }
      When { Atrium.config = value }
      Then { Atrium.config == "this is overridden facet config" }
    end
  end

end