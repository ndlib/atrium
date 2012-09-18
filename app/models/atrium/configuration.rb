class Atrium::Configuration < SimpleDelegator
  def initialize(default_configuration)
    super(default_configuration)
    yield(self) if block_given?
  end

  attr_writer :application_name
  def application_name
    @application_name || super
  rescue NoMethodError
    ''
  end
end