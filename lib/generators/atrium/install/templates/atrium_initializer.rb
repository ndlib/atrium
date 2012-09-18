Atrium.configure(CatalogController.blacklight_config) do |config|
  config.saved_search_class = "Search"
  config.saved_items_class = "SelectedItem"

  config.query_param_beautifier = lambda {|context,ugly_params|
    context.extend(Blacklight::SearchFields)
    context.extend(Blacklight::SearchHistoryConstraintsHelperBehavior)

    def context.blacklight_config
      CatalogController.blacklight_config
    end

    if context.respond_to?(:render_search_to_s)
      context.render_search_to_s(ugly_params)
    else
      ugly_params.inspect
    end
  }

  config.application_name = "An Atrium Application"
end