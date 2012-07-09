require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')

describe Atrium::Showcase::Item  do

  it { should belong_to :showcase }

  it { should be_accessible :type }

  it { should validate_presence_of :atrium_showcase_id }

  it { should validate_presence_of :solr_doc_id }
end
