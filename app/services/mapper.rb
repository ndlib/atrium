require 'nokogiri'
class Mapper
  attr_accessor :raise_errors
  attr_accessor :log_enabled, :log_level
  attr_accessor :li_counter

  def initialize
    self.log_level   = :info
    self.log_enabled = true
    self.li_counter  = 0
  end

  def parse(input)
    root = case input
             when String                  then Nokogiri::HTML(input).root
             when Nokogiri::XML::Document then input.root
             when Nokogiri::XML::Node     then input
           end
    process_element(root)
  end

  def process_element(element)
    output = ''
    output << if element.text?
      element.text.strip
    else
      opening(element)
    end
    unless element.name.eql?('sup')
      element.children.each do |child|
        output << process_element(child)
      end
    end

    output << ending(element) unless element.text?
    output
  end

  private

  def opening(element)
    parent = element.parent ? element.parent.name.to_sym : nil
    case element.name.to_sym
      when :html, :body
        ""
      when :li
        indent = '  ' * [(element.ancestors('ol').count + element.ancestors('ul').count - 1), 0].max
        if parent == :ol
          "#{indent}#{self.li_counter += 1}. "
        else
          "#{indent}- "
        end
      when :pre
        "\n"
      when :ol
        self.li_counter = 0
        "\n"
      when :ul, :root#, :p
        "\n"
      when :p
        if element.ancestors.map(&:name).include?('blockquote')
          "\n\n> "
        else
          "\n\n"
        end
      when :h1, :h2, :h3, :h4 # /h(\d)/ for 1.9
        element.name =~ /h(\d)/
        '#' * $1.to_i + ' '
      when :em
        "*"
      when :strong
        "**"
      when :blockquote
        "> "
      when :code
        parent == :pre ? "    " : "`"
      when :a
        if element.attribute('id').to_s =~ /^ftn(\d+)/
          "[^"
        else
          "["
        end
      when :img
        "!["
      when :hr
        "----------\n\n"
      when :sup
        "[^#{element.text.strip}"
      else
        handle_error "unknown start tag: #{element.name.to_s}"
        ""
    end
  end

  def ending(element)
    parent = element.parent ? element.parent.name.to_sym : nil
    case element.name.to_sym
      when :html, :body, :pre, :hr, :p
        ""
      when :h1, :h2, :h3, :h4 # /h(\d)/ for 1.9
        "\n"
      when :em
        '*'
      when :strong
        '**'
      when :li, :blockquote, :root, :ol, :ul
        "\n"
      when :code
        parent == :pre ? '' : '`'
      when :a
        if element.attribute('id').to_s =~ /^ftn(\d+)/
          "]:"
        else
          process_href(element)
        end
      when :img
        if element.has_attribute?('alt')
          "#{element.attribute('alt')}][#{element.attribute('src')}] "
        else
          "#{element.attribute('src')}] "
        end
      when :sup
        "]"
      else
        handle_error "unknown end tag: #{element.name}"
        ""
    end
  end

  def handle_error(message)
    if raise_errors
      raise ReverseMarkdown::ParserError, message
    elsif log_enabled && defined?(Rails)
      Rails.logger.__send__(log_level, message)
    end
  end

  def process_href(element)
    if element.text =~ /^INQ (\d+)/
      get_catalog_id(element.text.strip)
    else
      "](#{element.attribute('href').to_s})"
    end
  end

  def get_catalog_id(unique_key)
    "](need_to_get_id)"

  end

end

