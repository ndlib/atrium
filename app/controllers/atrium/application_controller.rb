module Atrium
  class ApplicationController < ActionController::Base
    include Atrium::ApplicationHelper
    #def atrium_config
    #  return @atrium_config if @atrium_config
    #  @atrium_config = OpenStruct.new
    #  @atrium_config.facet_name_map = [['Label','Key']]
    #
    #  @atrium_config
    #end
    def atrium_config
      Atrium.config
    end
    helper_method :atrium_config
   # protected :atrium_config
  end
end