module Atrium
  class MarkitupController < ApplicationController
    layout false

    include Atrium::MarkdownHelper

    def markdown
      @textile = markdown_parser(params[:data]).html_safe
    end

  end
end