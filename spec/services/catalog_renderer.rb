require_relative '../spec_helper'
require 'redcarpet'
require 'nokogiri'


describe CatalogRenderer do
  subject do
    Redcarpet::Markdown.new(CatalogRenderer)
  end
  context "non-override markdown syntax working with new renderer" do
    let(:input) {"This is *just* a test"}
    it do
      result = subject.render("This is *just* a test")
      result.should == "<p>This is <em>just</em> a test</p>"
    end
  end

  context "link with special char &# in markdown link within catalog" do
    let(:input) {"Testing override of *linking item* [**[INQ 32](&#RBSC-INQ:INQ_032 \"title attribute\")**] within catalog"}
    it do
      result = subject.render(input)
      result.should == "<p>Testing override of <em>linking item</em> [<strong><a title='title attribute' href='/catalog/RBSC-INQ:INQ_032'>INQ 32</a></strong>] within catalog</p>"
    end
  end

  context "link without special char in markdown linked as normal link" do
    let(:input) {"Testing override of *normal link* [**[test google link](http://google.com \"google\")**]"}
    it do
      result = subject.render(input)
      result.should == "<p>Testing override of <em>normal link</em> [<strong><a title='google' href='http://google.com'>test google link</a></strong>]</p>"
    end
  end
end

