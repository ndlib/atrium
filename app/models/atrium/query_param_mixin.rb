require 'active_support/concern'
module Atrium::QueryParamMixin
  extend ActiveSupport::Concern

  included do

    def find_saved_search_and_format_to_query(search_id)
      @saved_search_id = search_id
      return @saved_search_id unless @saved_search_id.present?
      saved_search = nil
      begin
        saved_search = Atrium.saved_search_class.find(search_id)
      rescue ActiveRecord::RecordNotFound
        @saved_search_id = nil
      end
      @saved_search_id = nil
      formatted_query_params = {}
      if saved_search
        if saved_search.query_params.has_key?(:f)
          formatted_query_params[:f] = saved_search.query_params[:f]
        end
        if saved_search.query_params.has_key?(:q)
          formatted_query_params[:q] = saved_search.query_params[:q]
        end
      end
      formatted_query_params
    end

    attr_reader :include_search_id

    attr_accessible :include_search_id

    def include_search_id=(value)
      return value unless value.present?
      self.filter_query_params = find_saved_search_and_format_to_query(value)
    end

    attr_reader :exclude_search_id

    attr_accessible :exclude_search_id

    def exclude_search_id=(value)
      return value unless value.present?
      query_params={}
      query_params[:exclude] =  find_saved_search_and_format_to_query(value)
      self.exclude_query_params=query_params
    end

    serialize :filter_query_params, Hash

    def filter_query_params
      begin
        super
      rescue ActiveRecord::SerializationTypeMismatch
        {}
      end
    end

    serialize :exclude_query_params, Hash

    def exclude_query_params
      begin
        super
      rescue ActiveRecord::SerializationTypeMismatch
        {}
      end
    end

    # This is a hopefully temporary work around that can be removed once all
    # atrium instances have a clean set of data.
    def read_attribute(attr_name)
      if attr_name.to_s == 'filter_query_params' || attr_name.to_s == 'exclude_query_params'
        begin
          super(attr_name)
        rescue ActiveRecord::SerializationTypeMismatch
          {}
        end
      else
        super
      end
    end

    attr_reader :remove_filter_query_params

    attr_accessible :remove_filter_query_params

    def remove_filter_query_params=(value)
      @remove_filter_query_params = value
      self.filter_query_params = nil if @remove_filter_query_params.to_i ==1
      @remove_filter_query_params = nil
    end

    attr_reader :remove_exclude_query_params

    attr_accessible :remove_exclude_query_params

    def remove_exclude_query_params=(value)
      @remove_exclude_query_params = value
      self.exclude_query_params = nil if @remove_exclude_query_params.to_i ==1
      @remove_exclude_query_params = nil
    end


  end
end