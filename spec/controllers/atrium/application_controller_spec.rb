require 'spec_helper'

describe Atrium::ApplicationController do
  it 'defines helper method #atrium_config' do
    controller.atrium_config.should == Atrium.config
  end
end
