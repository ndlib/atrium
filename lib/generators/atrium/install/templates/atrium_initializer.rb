Atrium.saved_search_class = "Search"

Atrium.query_param_beautifier = lambda {|context,ugly_params|
  context.extend(Blacklight::SearchFields)
  context.extend(Blacklight::SearchHistoryConstraintsHelperBehavior)
  if context.respond_to?(:render_search_to_s)
    context.render_search_to_s(ugly_params)
  else
    ugly_params.inspect
  end
}

atrium_config = {
  :facet => {
    :field_names => [
      "collection_0_did_0_unittitle_0_imprint_0_publisher_facet",
      "full_date_s",
      "collection_0_did_0_unittitle_0_imprint_0_geogname_facet",
      "collection_0_did_0_origination_0_printer_facet",
      "collection_0_did_0_origination_0_engraver_facet",
      "item_0_did_0_physdesc_0_dimensions_facet",
      "item_0_acqinfo_facet",
      "item_0_did_0_origination_0_persname_0_persname_normal_facet",
      "active_fedora_model_s",
      "date_s",
      "format" ,
      "pub_date" ,
      "subject_topic_facet",
      "language_facet",
      "lc_1letter_facet",
      "subject_geo_facet",
      "subject_era_facet"
    ],
      :labels => {
      "collection_0_did_0_unittitle_0_imprint_0_publisher_facet"=>"Publisher",
      "full_date_s"=>"Print Date",
      "collection_0_did_0_unittitle_0_imprint_0_geogname_facet"=>"Printing Location",
      "collection_0_did_0_origination_0_printer_facet"=>"Printer",
      "collection_0_did_0_origination_0_engraver_facet"=>"Engraver",
      "item_0_did_0_origination_0_persname_0_persname_normal_facet"=>"Signers",
      "active_fedora_model_s" => "Description",
      "date_s"=>"Print Year",
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
