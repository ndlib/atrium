require 'atrium/engine'

module Atrium
  require 'ckeditor-rails'

  mattr_accessor :saved_search_class, :facet_config, :config, :saved_items_class
  class << self
    def saved_searches_for(user)
      if user
        saved_search_class.where(user_id: user[:id])
      else
        []
      end
    end

    def saved_items_class
      #TODO as saved_search_class
      "SelectedItem".constantize
    end

    def saved_search_class
      error = "Please define Atrium.saved_search_class in config/initializer/atrium.rb"
      if @@saved_search_class.is_a?(String)
        @@saved_search_class.constantize
      else
        raise(Atrium::ConfigurationNotSet, error)
      end
    end

    def config
      @@config || self.facet_config
    end

    def saved_items_for(user)
      if user
        saved_items_class.where(user_id: user[:id])
      else
        []
      end
    end

    def facet_config
      return @default_config if @default_config

      @default_config = OpenStruct.new
      @default_config = {
          :facet => {
              :field_names => [
                  "active_fedora_model_s",
                  "date_s",
                  "format" ,
                  "pub_date" ,
                  "subject_topic_facet"
              ],
              :labels => {
                  "active_fedora_model_s" => "Description",
                  "date_s"=>"Print Year",
                  "format" => "Format",
                  "pub_date" => "Publication Year",
                  "subject_topic_facet" => "Topic"
              }
          }
      }
      @default_config
    end

  end

  class ConfigurationNotSet < StandardError

  end


end
