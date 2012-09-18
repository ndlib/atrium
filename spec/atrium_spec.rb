require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ostruct'

describe Atrium do
  context '.configure' do
    Given(:main_app_config) { OpenStruct.new }
    When { Atrium.configure(main_app_config) }
    Then { Atrium.configuration.should be_instance_of(Atrium::Configuration) }
  end

  context ".query_param_beautifier=" do
    after(:each) do
      Atrium.query_param_beautifier = nil
    end
    it 'should raise exception if not callable' do
      expect {
        Atrium.query_param_beautifier = 1
      }.to raise_error(Atrium::ConfigurationExpectation)
    end
    it 'should raise exception if improper :arity' do
      expect {
        Atrium.query_param_beautifier = lambda {}
      }.to raise_error(Atrium::ConfigurationExpectation)
    end
  end

  context "Search Class exists or not" do
    after(:each) do
      Atrium.saved_search_class = nil
    end
    Given(:config) {  lambda {Atrium.saved_search_class} }
    context 'saved_search_class not set in application' do
      Then { config.should raise_error(Atrium::ConfigurationNotSet) }
    end
    context 'saved_search_class set in application' do
      When {Atrium.saved_search_class = "SavedSearch"}
      Then { config.should_not raise_error(Atrium::ConfigurationNotSet)}
    end
  end

  context "Save Item Class exists or not" do
    after(:each) do
      Atrium.saved_items_class = nil
    end
    Given(:config) {  lambda {Atrium.saved_items_class} }
    context 'saved_items_class not set in application' do
      Then { config.should raise_error(Atrium::ConfigurationNotSet) }
    end
    context 'saved_items_class set in application' do
      When {Atrium.saved_items_class = "SavedItem"}
      Then { config.should_not raise_error(Atrium::ConfigurationNotSet)}
    end
  end

  context 'Configuration settings' do
    before(:each) do
      @old_config = Atrium.config
    end
    after(:each) do
      Atrium.config = @old_config if @old_config
    end
    context 'should have a default value' do
      Then { Atrium.config.should == Atrium.default_config }
    end
    context 'should be able to override the default value' do
      Given(:custom_configuration) { { application_name: 'My Custom Atrium Application' } }
      When { Atrium.config = custom_configuration }
      Then { Atrium.config == { application_name: 'My Custom Atrium Application' } }
    end
  end

end
