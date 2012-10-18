require 'open-uri'
module Atrium
  module MarkdownHelper
    def markdown_parser(content)
      options = {:hard_wrap => true, :autolink => true, :lax_html_blocks =>true}
      renderer = CatalogRenderer.new
      markdown = Redcarpet::Markdown.new(renderer, options)
      return markdown.render(content).html_safe
    end

    def convert_to_markdown(url)
      unless url.blank?
        content= open(url){|f|f.read}
        p = Mapper.new.parse(content)
        return p
      end
      return ''
    end

    def from_fedora
      #TODO Add hooks to get datastream url to convert html to markdown
      url=''
      markdown=convert_to_markdown(url)
      return markdown_parser(markdown).html_safe
    end

  end
end
