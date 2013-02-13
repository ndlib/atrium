require_relative 'html_markdown_converter'
namespace :atrium do
  desc "Convert html from fedora to markdown"
  task :markdown  => :environment do
    if ENV['PID'] && ENV['DSNAME']
      pid= ENV['PID']
      ds_name=ENV['DSNAME']
      converter = HtmlMarkdownConverter::MarkdownConvert.new
      converter.parser(pid,ds_name)
    else
      puts "Please specify the pid and datastream name with format PID=<pid> DSNAME=<datastream_name>"
    end
  end
end