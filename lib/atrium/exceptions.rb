module Atrium
  class ConfigurationExpectation < RuntimeError
  end

  class ConfigurationNotSet < StandardError
    def initialize(method_name)
      super("Please define #{method_name} in config/initializer/atrium.rb")
    end
  end
end
