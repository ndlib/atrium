require 'spec_helper'
require 'ostruct'

describe Atrium::Configuration do
  Given(:main_app_config) {
    OpenStruct.new(application_name: default_application_name )
  }
  Given(:configuration) { Atrium::Configuration.new(main_app_config) }
  Given(:default_application_name) { "Good-Bye World"}
  Given(:expected_application_name) { 'Hello World' }

  context '#saved_search_class' do
    context 'when set' do
      Given(:saved_search_class_name) { 'Object' }
      When { configuration.saved_search_class = saved_search_class_name }
      Then { configuration.saved_search_class.should == Object }
    end
    context 'when not set' do
      Then {
        expect {
          configuration.saved_search_class
        }.to raise_error(Atrium::ConfigurationNotSet)
      }
    end
  end

  context '#saved_items_class' do
    context 'when set' do
      Given(:saved_items_class_name) { 'Object' }
      When { configuration.saved_items_class = saved_items_class_name }
      Then { configuration.saved_items_class.should == Object }
    end
    context 'when not set' do
      Then {
        expect {
          configuration.saved_items_class
        }.to raise_error(Atrium::ConfigurationNotSet)
      }
    end
  end

  context "#query_param_beautifier=" do
    Then('raise exception if not callable') {
      expect {
        configuration.query_param_beautifier = 1
      }.to raise_error(Atrium::ConfigurationExpectation)
    }
    Then('raise exception if improper arity') {
      expect {
        Atrium.query_param_beautifier = lambda {}
      }.to raise_error(Atrium::ConfigurationExpectation)
    }
  end

  context "#query_param_beautifier" do
    Given(:params) { ['a', 'b'] }
    Given(:context) { Object.new }
    context 'without override' do
      Then {
        configuration.query_param_beautifier(context, params).
        should == params.inspect
      }
    end
    context 'with override' do
      Given(:expected_output) { "#{context.class}: #{params.reverse.inspect}" }
      When {
        configuration.query_param_beautifier =
        lambda { |context,params| expected_output }
      }
      Then {
        configuration.query_param_beautifier(context, params).
        should == expected_output
      }
    end
  end

  context '#application_name' do
    context 'override via config' do
      When { configuration.application_name = expected_application_name }

      Then { configuration.application_name.should == expected_application_name }
    end

    context 'defer to main app config' do
      Then { configuration.application_name.should == default_application_name }
    end

    context 'gracefully handle not having application name set' do
      Given(:main_app_config) { OpenStruct.new }
      Then { configuration.application_name.should == '' }
    end
  end
end
