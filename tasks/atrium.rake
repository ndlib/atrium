require 'rspec/core'
require 'rspec/core/rake_task'
require 'thor/core_ext/file_binary_read'
require 'jettywrapper'

namespace :atrium do

  desc "Execute Continuous Integration build (docs, tests with coverage)"
  task :ci do
    Rake::Task["atrium:doc"].invoke

    jetty_params = {
      :jetty_home   => File.expand_path(File.dirname(__FILE__) + '/../jetty'),
      :quiet        => false,
      :jetty_port   => 8983,
      :solr_home    => File.expand_path(File.dirname(__FILE__) + '/../jetty/solr'),
      :startup_wait => 30
    }
    error = Jettywrapper.wrap(jetty_params) do
      Rake::Task['atrium:setup_test_app'].invoke
      Rake::Task['atrium:test'].invoke
    end
    raise "test failures: #{error}" if error
  end


  desc "Easiest way to run rspec tests. Copies code to host plugins dir, loads fixtures, then runs specs - need to have jetty running."
  #task :spec => "rspec:setup_and_run"

  namespace :rspec do

    desc "Run the atrium specs - need to have jetty running, test host set up and fixtures loaded."
    task :run => :use_test_app do
      puts "Running rspec tests"
      puts Rake::Task["atrium:spec"].invoke
      FileUtils.cd('../../')
    end

    desc "Sets up test host, loads fixtures, then runs specs - need to have jetty running."
    task :setup_and_run => ["atrium:setup_test_app"] do
      puts "Reloading fixtures"
      Rake::Task["atrium:rspec:run"].invoke

    end

  end


  # The following is a task named :doc which generates documentation using yard
  begin
    require 'yard'
    require 'yard/rake/yardoc_task'
    project_root = File.expand_path("#{File.dirname(__FILE__)}/../")
    doc_destination = File.join(project_root, 'doc')
    if !File.exists?(doc_destination)
      FileUtils.mkdir_p(doc_destination)
    end

    YARD::Rake::YardocTask.new(:doc) do |yt|
      readme_filename = 'README.textile'
      textile_docs = []
      Dir[File.join(project_root, "*.textile")].each_with_index do |f, index|
        unless f.include?("/#{readme_filename}") # Skip readme, which is already built by the --readme option
          textile_docs << '-'
          textile_docs << f
        end
      end
      yt.files   = Dir.glob(File.join(project_root, '*.rb')) +
                   Dir.glob(File.join(project_root, 'app', '**', '*.rb')) +
                   Dir.glob(File.join(project_root, 'lib', '**', '*.rb')) +
                   textile_docs
      yt.options = ['--output-dir', doc_destination, '--readme', readme_filename]
    end
  rescue LoadError
    desc "Generate YARD Documentation"
    task :doc do
      abort "Please install the YARD gem to generate rdoc."
    end
  end

   #
  # Cucumber
  #


  desc "Run cucumber tests for atrium - need to have jetty running, test host set up and fixtures loaded."
  task :cucumber => ['test:prepare'] do
    within_test_app do
      puts "Running cucumber features in test host app #{Dir.pwd}"
      puts Rake::Task["atrium:cucumber:cmd"].invoke
    end
  end


  namespace :cucumber do
    # atrium_features, where to find features inside atrium source?
    atrium_features = File.expand_path("../test_support/features",File.dirname(__FILE__))
    vendored_cucumber_bin = Dir[File.expand_path("../vendor/{gems,plugins}/cucumber*/bin/cucumber",File.dirname(__FILE__))].first
    $LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?
    require 'cucumber/rake/task'
    ### Don't call this directly, use atrium:cucumber
    #Cucumber::Rake::Task.new(:cmd => 'atrium:db:seed') do |t|
    Cucumber::Rake::Task.new(:cmd => 'atrium:db:seed') do |t|
      t.cucumber_opts = atrium_features
      t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
    end
  end

  #
  # Misc Tasks
  #

  desc "Creates a new test app"
  task :setup_test_app => [:set_test_host_path] do
    path = TEST_HOST_PATH
    errors = []
    puts "Cleaning out test app path #{path}"
    puts %x[rm -fr #{path}]
    errors << 'Error removing test app' unless $?.success?

    ###puts "Freezing gems to project vendor/cache"
    ###puts %x[bundle package]
    ###errors << 'Bundle package failed' unless $?.success?

    puts "Creating test app directory"
    FileUtils.mkdir_p(path)

    puts "Installing rails, bundler and devise"
    %x[gem install --no-rdoc --no-ri 'rails' -v "<4"]
    %x[gem install --no-rdoc --no-ri 'bundler']

    #puts "Copying over .rvmrc file"
    #FileUtils.cp("./test_support/etc/rvmrc",File.join(path,".rvmrc"))
    FileUtils.cd("tmp")
    #system("source ./test_app/.rvmrc")

    puts "Generating new rails app"
    %x[bundle exec rails new test_app]
    errors << 'Error generating new rails test app' unless $?.success?
    FileUtils.cd('test_app')
    FileUtils.rm('public/index.html')

    puts "Copying Gemfile from test_support/etc"
    FileUtils.cp('../../test_support/etc/Gemfile','./Gemfile')

    #puts "Creating local vendor/cache dir and copying gems from atrium gemset"
    #FileUtils.cp_r(File.join('..','..','vendor','cache'), './vendor')

    #puts "Configure bundler to only look at the local vendor/cache"
    #FileUtils.mkdir_p( File.expand_path('./.bundle') )
    #FileUtils.cp_r(File.expand_path('../../test_support/etc/bundle_config'), File.expand_path('./.bundle/config'))

    puts "Copying fixtures into test app spec/fixtures directory"
    FileUtils.mkdir_p( File.join('.','test_support') )
    FileUtils.cp_r(File.join('..','..','test_support','fixtures'), File.join('.','test_support','fixtures'))

    puts "Executing bundle install"
    puts %x[bundle install]
    errors << 'Error running bundle install in test app' unless $?.success?

    puts "Installing jQuery UJS in test app"
    puts %x[bundle exec rails g jquery:install]
    errors << 'Error installing jquery-rails in test app' unless $?.success?

    puts "Installing cucumber in test app"
    puts %x[bundle exec rails g cucumber:install]
    errors << 'Error installing cucumber in test app' unless $?.success?

    puts "Generating default blacklight install"
    puts %x[bundle exec rails g blacklight --devise]
    errors << 'Error generating default blacklight install' unless $?.success?

    puts "Generating default atrium install"
    puts %x[bundle exec rails g atrium -df] # using -f to force overwriting of solr.yml
    errors << 'Error generating default atrium install' unless $?.success?

    after = 'TestApp::Application.configure do'
    replace!( "#{path}/config/environments/test.rb",  /#{after}/, "#{after}\n    config.log_level = :warn\n")

    puts FileUtils.cp('../../lib/generators/atrium/templates/db/seeds.rb','db/seeds.rb')

    #puts "Loading blacklight marc test data into Solr"
    #%x[bundle exec rake solr:marc:index_test_data]

    puts "Running rake db:migrate"
    puts %x[bundle exec rake db:migrate]    
    errors << 'Error running db:migrate in test app' unless $?.success?

    puts %x[bundle exec rake db:migrate RAILS_ENV=test]
    errors << 'Error running db:migrate RAILS_ENV=test in test app' unless $?.success?

	  #raise "Errors: #{errors.join("; ")}" unless errors.empty?
	
    FileUtils.cd('../../')
  end 
  

  task :set_test_host_path do
    TEST_HOST_PATH = File.join(File.expand_path(File.dirname(__FILE__)),'..','tmp','test_app')
    puts "Test app path:\n#{TEST_HOST_PATH}"
  end

  #
  # Test
  #

  desc "Run tests against test app"
  task :test => [:use_test_app]  do

    puts "Running rspec tests"
    puts  %x[bundle exec rake atrium:spec:rcov]
    puts  %x[bundle exec rake atrium:rspec:run]

    puts "Running cucumber tests"
    puts %x[bundle exec rake atrium:cucumber]

    FileUtils.cd(File.expand_path(File.dirname(__FILE__)))
    puts "Completed test suite"
  end

  namespace :test do

    desc "run db:test:prepare in the test app"
    task :prepare => :test_app_exists do
      within_test_app do
        %x[rake db:test:prepare]
      end
    end

    desc "Make sure the test app is installed"
    task :test_app_exists => [:set_test_host_path] do
      Rake::Task['atrium:setup_test_app'].invoke unless File.exist?(TEST_HOST_PATH)
    end

  end

  namespace :db do
    desc "Seed the database with once/ and always/ fixtures."
    task :seed => ["atrium:test:test_app_exists"] do
      within_test_app do
          puts %x[bundle exec rake db:seed RAILS_ENV=test]
      end
    end
  end

  desc "Make sure the test app is installed, then run the tasks from its root directory"
  task :use_test_app => [:set_test_host_path] do
    Rake::Task['atrium:setup_test_app'].invoke unless File.exist?(TEST_HOST_PATH)
    FileUtils.cd(TEST_HOST_PATH)
  end
end




# Adds the content to the file.
#
def replace!(destination, regexp, string)
  content = File.binread(destination)
  content.gsub!(regexp, string)
  File.open(destination, 'wb') { |file| file.write(content) }
end

def within_test_app
  FileUtils.cd(TEST_HOST_PATH)
  yield
  FileUtils.cd('../../')
end
