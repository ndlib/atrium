require 'spec_helper'

describe Atrium do
  describe 'Configuration exists or not' do
  it "saved_search_class must be set" do
    config = lambda {Atrium.saved_search_class}
    error = "Please define Atrium::Engine.saved_search_class in config/initializer/atrium.rb"
    config.should raise_error(Atrium::ConfiguarationNotSet, error)
    Atrium.saved_search_class = "SavedSearch"
    config.should_not raise_error(Atrium::ConfiguarationNotSet)
  end
end
end