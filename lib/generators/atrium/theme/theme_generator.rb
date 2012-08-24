class Atrium::ThemeGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_theme
    # TODO: warning magic string "atrium_themes" to refactor
    copy_file(
      'theme.html.erb',
      File.join('app/views/layouts/atrium_themes/', "#{file_name}.html.erb")
    )
  end
end
