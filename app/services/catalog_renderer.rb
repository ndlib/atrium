class CatalogRenderer < Redcarpet::Render::HTML

  def initialize
    super
  end

  def link(link, title, content)
    link.gsub!(/&#/, '/catalog/')
    "<a title='#{title}' href='#{link}'>#{content}</a>"
  end

  def paragraph(text)
    if text =~ /^\[\^(\d+)\]:(.+)$/
      #footnote list pattern: [^<any number>]:explain foot note here
      linkback = %(<a href="#footnote-#{$1}-ref"><sup>#{$1}</sup></a>)
      %(<p class="footnote" id="footnote-#{$1}">#{linkback} #{$2}</p>)
    else
      text = convert_footnotes(text)
      "<p>#{text}</p>"
    end
  end

  private

  def convert_footnotes(text)
    #footnote reference parsing: [^<any number>]
    text.gsub(/\[\^(\d+)\]/i) do
      %(<sup class="footnote" id="footnote-#{$1}-ref">) +
          %(<a href="#footnote-#{$1}">#{$1}</a></sup>)
    end
  end

end