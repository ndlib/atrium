module Atrium
  class Configuration < SimpleDelegator
    def initialize(default_configuration)
      super(default_configuration)
      yield(self) if block_given?
    end

    attr_writer :application_name
    def application_name
      @application_name || super
    rescue NoMethodError
      ''
    end

    attr_writer :saved_search_class
    def saved_search_class
      if @saved_search_class.respond_to?(:constantize)
        @saved_search_class.constantize
      else
        raise(Atrium::ConfigurationNotSet, 'Atrium.config.saved_search_class')
      end
    end
  end
end
