require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Atrium::Essay do
  subject { Atrium::Essay.new(content: 'Hello') }
  it { should belong_to :description }

  it { should be_accessible :content }
  it { should be_accessible :content_type }

  it { should validate_presence_of :description }

  it 'should delegate #blank? to #content#blank?' do
    subject.content.should_receive(:blank?).and_return(:blank)
    subject.blank?.should == :blank
  end
end
