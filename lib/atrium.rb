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

  mattr_accessor :saved_search_class, :config, :saved_items_class
  class << self
    def configure(main_app_config, &block)
      @configuration = Atrium::Configuration.new(main_app_config, &block)
    end

    def configuration
      @configuration
    end

    def saved_searches_for(user)
      if user
        saved_search_class.where(user_id: user[:id])
      else
        []
      end
    end

    def query_param_beautifier=(callable)
      if callable.nil?
        @@query_param_beautifier = nil
        return callable
      end
      if ! callable.respond_to?(:call)
        message = "Expected Atrium.query_param_beautifier to respond to :call"
        raise ConfigurationExpectation, message
      end
      if callable.arity != 2
        message = "Expected Atrium.query_param_beautifier to require 2 args"
        raise ConfigurationExpectation, message
      end
      @@query_param_beautifier = callable
    end

    def query_param_beautifier(context,query_params)
      if defined?(@@query_param_beautifier) && @@query_param_beautifier
        @@query_param_beautifier.call(context,query_params)
      else
        query_params.inspect
      end
    end

    def saved_items_class
      if @@saved_items_class.respond_to?(:constantize)
        @@saved_items_class.constantize
      else
        raise(Atrium::ConfigurationNotSet, 'Atrium.saved_items_class')
      end
    end

    delegate :saved_search_class, :to => :configuration

    def saved_search_class
      if @@saved_search_class.respond_to?(:constantize)
        @@saved_search_class.constantize
      else
        raise(Atrium::ConfigurationNotSet, 'Atrium.saved_search_class')
      end
    end


    def config
      @@config || default_config
    end

    def application_name
      config[:application_name]
    end

    def saved_items_for(user)
      if user
        saved_items_class.where(user_id: user[:id])
      else
        []
      end
    end

    def default_config
      {
        facet: {
          field_names: [
            'active_fedora_model_s',
            'date_s',
            'format' ,
            'pub_date' ,
            'subject_topic_facet'
          ],
            labels: {
            'active_fedora_model_s' => 'Description',
            'date_s'=>'Print Year',
            'format' => 'Format',
            'pub_date' => 'Publication Year',
            'subject_topic_facet' => 'Topic'
          }
        },
        application_name: 'Atrium Application'
      }
    end

  end
end
