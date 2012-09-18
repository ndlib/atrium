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

    def label_for_facet(facet_name)
      self[facet_name].label
    rescue NoMethodError
      facet_name
    end

    attr_writer :saved_search_class
    def saved_search_class
      if @saved_search_class.respond_to?(:constantize)
        @saved_search_class.constantize
      else
        raise(Atrium::ConfigurationNotSet, 'Atrium.config.saved_search_class')
      end
    end

    attr_writer :saved_items_class
    def saved_items_class
      if @saved_items_class.respond_to?(:constantize)
        @saved_items_class.constantize
      else
        raise(Atrium::ConfigurationNotSet, 'Atrium.config.saved_items_class')
      end
    end

    def query_param_beautifier=(callable)
      if callable.nil?
        @query_param_beautifier = nil
        return callable
      end
      if ! callable.respond_to?(:call)
        message = "Expected Atrium.query_param_beautifier to respond to :call"
        raise Atrium::ConfigurationExpectation, message
      end
      if callable.arity != 2
        message = "Expected Atrium.query_param_beautifier to require 2 args"
        raise Atrium::ConfigurationExpectation, message
      end
      @query_param_beautifier = callable
    end

    def query_param_beautifier(context,query_params)
      if defined?(@query_param_beautifier) && @query_param_beautifier
        @query_param_beautifier.call(context,query_params)
      else
        query_params.inspect
      end
    end

  end
end
