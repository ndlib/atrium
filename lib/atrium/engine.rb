module Atrium
  class Engine < ::Rails::Engine
    isolate_namespace Atrium
    config.generators do |g|
      g.test_framework :rspec, :fixture => false
    end
    #class << self
    #  attr_accessor :saved_search_class
    #end
    #
    #def self.saved_search_class
    #  puts @saved_search_class.inspect
    #  error = "Please define Atrium::Engine.saved_search_class in config/initializer/atrium.rb"
    #  @saved_search_class || raise(Atrium::ConfiguarationNotSet, error)
    #end

  end

end
