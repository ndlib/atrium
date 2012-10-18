require 'spec_helper'
require 'redcarpet'

describe Atrium::MarkdownHelper do
  describe "markdown_parser" do
    subject do
      Redcarpet::Markdown.new(CatalogRenderer)
    end
    context "non-override markdown syntax working with new renderer" do
      let(:input) {"This is *just* a test"}
      it do
        result = helper.markdown_parser(input)
        result.should == "<p>This is <em>just</em> a test</p>"
      end
    end
  end
end

