class Atrium::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_initializer
    template(
      'atrium_initializer.rb',
      'config/initializers/atrium.rb'
    )
  end

  def update_routes
    route(%q{mount Atrium::Engine => '/atrium', as: 'atrium'})
    route(%q{resources :collections, only: [:show] do
      get 'browse', on: :member
    end})
    route(%q{resources :exhibits, only: [:show]})
    route(%q{resources :descriptions})
    route(%q{match 'selected_items/save',
      to: 'selected_items#save',
      as: 'save_selected_items',
      via: :post})
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

  def update_user_model
    inject_into_file 'app/models/user.rb',
      :before => "def to_s" do
      [
          "",
          " has_many     :selected_items, :class_name => 'SelectedItem',   :dependent => :destroy",
          "",
          " def selected_document_ids",
          "   self.selected_items.map{|item|item.document_id}",
          " end",
          "",
          ""
      ].join("\n")
    end
  end

  def create_controllers
    raw_install('controllers')
  end

  def create_models
    raw_install('models')
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
