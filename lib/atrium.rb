require 'atrium/engine'
require 'atrium/exceptions'
module Atrium
  require 'ckeditor-rails'

  class << self
    def configure(main_app_config, &block)
      @config = Atrium::Configuration.new(main_app_config, &block)
    end

    def config
      @config || configure(OpenStruct.new)
    end

    delegate(
      :application_name,
      :query_param_beautifier,
      :query_param_beautifier=,
      :saved_search_class,
      :saved_search_class=,
      :saved_items_class,
      :saved_items_class=,
      to: :config
    )

    def saved_searches_for(user)
      if user
        saved_search_class.where(user_id: user[:id])
      else
        []
      end
    end

    def saved_items_for(user)
      if user
        saved_items_class.where(user_id: user[:id])
      else
        []
      end
    end

  end
end
