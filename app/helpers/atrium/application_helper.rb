module Atrium
  module ApplicationHelper

    def application_name
      Atrium.application_name.html_safe rescue nil
    end
  end
end
