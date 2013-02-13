require 'rubygems'
require 'logger'
require 'open-uri'

module HtmlMarkdownConverter
  class MarkdownConvert

    def log
      @log ||= Logger.new("markdown_converter.log")
    end

    def parser(pid,ds_name)
      log.info("*************************************************************************************")
      log.info("\t Starting to parse #{Time.now}.")
      log.info("*************************************************************************************")
      host = 'https://fedoraprod.library.nd.edu:8443'
      #pid='RBSC-INQ:ESSAY_InquisitorialManuals'
      #ds_name= 'ESSAYDATASTREAM1'
      url= "#{host}/fedora/get/#{pid}/#{ds_name}"
      markdown= convert_to_markdown(url)
      log.info("*************************************************************************************")
      log.info("\n Printing markdown \n #{markdown.inspect}.\n")
      log.info("End of printing *************************************************************************************")
      log.info("\t End of parsing for #{Time.now}.")
    end

    def convert_to_markdown(url)
      puts url.inspect
      unless url.blank?
        content= open(url){|f|f.read}
        p = Mapper.new.parse(content)
        return p
      end
      return ''
    end

  end
end