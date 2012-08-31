module Atrium
  class ApplicationController < ActionController::Base
    include Atrium::ApplicationHelper
    include Atrium::ApplicationHelper
    include Atrium::CollectionsHelper
    include Atrium::ShowcasesHelper

    def atrium_user
      current_user
    end
    helper_method :atrium_user

    def sign_in_path
      new_user_session_path
    end

    def atrium_config
      Atrium.config
    end
    helper_method :atrium_config
  end
end