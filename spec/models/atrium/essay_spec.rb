require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::Essay do

  it { should belong_to :description }

  it { should be_accessible :content }
  it { should be_accessible :content_type }

  it { should validate_presence_of :description }

end
