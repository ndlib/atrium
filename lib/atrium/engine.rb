require "atrium"
require "rails"
module Atrium
  class Engine < Rails::Engine

    # AtriumHelper is needed by all helpers, so we inject it
    # into action view base here.
    initializer 'atrium.helpers' do |app|
      ActionView::Base.send :include, Atrium::BaseHelper
    end
  end
end
