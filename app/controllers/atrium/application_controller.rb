module Atrium
  class ApplicationController < ActionController::Base
    include Atrium::ApplicationHelper
    include Atrium::CollectionsHelper
    include Atrium::ShowcasesHelper

    def atrium_config
      Atrium.config
    end
    helper_method :atrium_config
  end
end