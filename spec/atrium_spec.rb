require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'ostruct'

describe Atrium do
  context '.configure' do
    Given(:main_app_config) { OpenStruct.new }
    When { Atrium.configure(main_app_config) }
    Then { Atrium.configuration.should be_instance_of(Atrium::Configuration) }
  end
end
