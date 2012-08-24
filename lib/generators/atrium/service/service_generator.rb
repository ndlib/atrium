class Atrium::ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_service
    template(
      'service.rb.erb',
      File.join('app/services/', "#{file_name}.rb")
    )
  end
  def create_service_spec
    template(
      'service_spec.rb.erb',
      File.join('spec/services/', "#{file_name}_spec.rb")
    )
  end
end
