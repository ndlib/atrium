require 'atrium/engine'

module Atrium
  require 'ckeditor-rails'

  class ConfigurationExpectation < RuntimeError
  end

  class ConfigurationNotSet < StandardError
    def initialize(method_name)
      super("Please define #{method_name} in config/initializer/atrium.rb")
    end
  end

  class << self
    def configure(main_app_config, &block)
      @configuration = Atrium::Configuration.new(main_app_config, &block)
    end

    def configuration
      @configuration || configure(OpenStruct.new)
    end
    def config
      @configuration || configure(OpenStruct.new)
    end

    def saved_searches_for(user)
      if user
        saved_search_class.where(user_id: user[:id])
      else
        []
      end
    end

    delegate(
      :application_name,
      :query_param_beautifier,
      :query_param_beautifier=,
      :saved_search_class,
      :saved_search_class=,
      :saved_items_class,
      :saved_items_class=,
      to: :configuration
    )

    delegate :saved_search_class, :to => :configuration

    def saved_items_for(user)
      if user
        saved_items_class.where(user_id: user[:id])
      else
        []
      end
    end

  end
end
