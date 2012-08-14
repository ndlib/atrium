require 'atrium/engine'

module Atrium
  require 'ckeditor-rails'

  mattr_accessor :saved_search_class
  class << self
    def saved_searches_for(user)
      if user
        saved_search_class.where(user_id: user[:id])
      else
        []
      end
    end

    def saved_search_class
      error = "Please define Atrium::Engine.saved_search_class in config/initializer/atrium.rb"
      if @@saved_search_class.is_a?(String)
        @@saved_search_class.constantize
      else
        raise(Atrium::ConfiguarationNotSet, error)
      end
    end
  end

  class ConfiguarationNotSet < StandardError

  end

  def self.config
    return @atrium_config if @atrium_config
    @atrium_config = OpenStruct.new
    @atrium_config = {
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
    },
            :limits=> {nil=>10}
        }
    }
    @atrium_config
  end
end
