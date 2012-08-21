module Atrium
  class Showcase::FeaturedSelection
    include Atrium::ApplicationHelper

    attr_reader :solr_id, :title

    def initialize(selected_item_hash)
      @solr_id = selected_item_hash[:id]
      @title = selected_item_hash[:title]
    end


  end
end

