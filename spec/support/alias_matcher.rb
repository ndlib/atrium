# RSpec matcher to spec alias.
RSpec::Matchers.define :alias_from do |method_name|
  match do |object|
    @method_name = method_name
    @object = object
    @from_returned_value = double('receiver')
    @object.stub(@method_name).and_return(@from_returned_value)
    @object.send(@to) == @from_returned_value
  end

  description do
    "alias from :#{@method_name} to :#{@to}"
  end

  failure_message_for_should do |text|
    "expected #{@object} to alias from :#{@method_name} to :#{@to}"
  end

  failure_message_for_should_not do |text|
    "expected #{@object} NOT to alias from :#{@method_name} to :#{@to}"
  end

  chain(:to) { |receiver| @to = receiver }
end