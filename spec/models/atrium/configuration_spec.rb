require 'spec_helper'
require 'ostruct'

describe Atrium::Configuration do
  Given(:main_app_config) {
    OpenStruct.new(application_name: default_application_name )
  }
  Given(:configuration) { Atrium::Configuration.new(main_app_config) }
  Given(:default_application_name) { "Good-Bye World"}
  Given(:expected_application_name) { 'Hello World' }

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
