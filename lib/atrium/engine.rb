module Atrium
  class Engine < ::Rails::Engine
    isolate_namespace Atrium
    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end
  end
end
