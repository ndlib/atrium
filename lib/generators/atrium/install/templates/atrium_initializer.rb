Atrium.saved_search_class = "Search"

Atrium.saved_items_class = "SelectedItem"

Atrium.query_param_beautifier = lambda {|context,ugly_params|
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

atrium_config = {
  :facet => {
    :field_names => [
      "format" ,
      "pub_date" ,
      "subject_topic_facet",
      "language_facet",
      "lc_1letter_facet",
      "subject_geo_facet",
      "subject_era_facet"
    ],
      :labels => {
      "format" => "Format",
      "pub_date" => "Publication Year",
      "subject_topic_facet" => "Topic",
      "language_facet" => "Language",
      "lc_1letter_facet" => "Call Number" ,
      "subject_geo_facet" => "Region",
      "subject_era_facet" => "Era"
    }
  },
  :application_name => "Digitial Collections &mdash; Rare Books &amp; Special Collections"
}

Atrium.config = atrium_config