class Atrium::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_initializer
    template(
      'atrium_initializer.rb',
      'config/initializers/atrium.rb'
    )
  end

  def update_controllers
    inject_into_class(
      'app/controllers/application_controller.rb',
      'ApplicationController'
    ) do
      [
        "",
        "  def blacklight_config",
        "    CatalogController.blacklight_config",
        "  end",
        "  helper_method :blacklight_config",
        "  protected :blacklight_config",
        ""
      ].join("\n")
    end
  end

  def create_controllers
    raw_install('controllers')
  end

  def create_helpers
    raw_install('helpers')
  end

  def create_views
    raw_install('views')
  end

  private
  def raw_install(context)
    container_directory = File.join(source_paths.first, '/')
    directory_pattern = File.join(container_directory, context, '/**/*.*')
    Dir.glob(directory_pattern).each do |file_name|
      relative_filename = file_name.sub(container_directory, "")
      copy_file(
        relative_filename,
        File.join('app', relative_filename)
      )
    end

  end
end
