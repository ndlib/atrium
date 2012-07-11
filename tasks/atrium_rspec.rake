# Atrium customization of the Rake tasks that come with rspec-2, to run
# specs located in alternate location (inside the Atrium plugin), and to provide
# rake tasks for jetty/solr wrapping.
#
# Same tasks as in ordinary rspec, but prefixed with atrium:.
#
# rspec2 keeps it's rake tasks inside it's own code, it doesn't generate them.
# We had to copy them from there and modify, may have to be done again
# if rspec2 changes a lot, but this code looks relatively cleanish.
begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
  if default = Rake.application.instance_variable_get('@tasks')['default']
    default.prerequisites.delete('test')
  end

  spec_prereq = "atrium:test:prepare"
  atrium_spec = File.expand_path("../test_support/spec",File.dirname(__FILE__))
  directories_to_test = [
    :controllers,
    # :generators,
    :helpers,
    # :integration,
    # :lib,
    # :mailers,
    :models,
    # :requests,
    # :routing,
    # :unit,
    # :utilities,
    # :views
  ]

  # Set env variable to tell our spec/spec_helper.rb where we really are,
  # so it doesn't have to guess with relative path, which will be wrong
  # since we allow spec_dir to be in a remote location. spec_helper.rb
  # needs it before Rails.root is defined there, even though we can
  # oddly get it here, i dunno.
  #ENV['RAILS_ROOT'] = Rails.root.to_s

  namespace :atrium do
    desc "Run all specs in spec directory (excluding plugin specs)"
    RSpec::Core::RakeTask.new(:spec => spec_prereq) do |t|
      # the user might not have run rspec generator because they don't
      # actually need it, but without an ./.rspec they won't get color,
      # let's insist.
      t.rspec_opts = "--colour"

      # pattern directory name defaults to ./**/*_spec.rb, but has a more concise command line echo
      t.pattern = "#{atrium_spec}"
    end

    # Don't understand what this does or how to make it use our remote stats_directory
    #task :stats => "spec:statsetup"
    namespace :spec do
      directories_to_test.each do |sub|
        desc "Run the code examples in spec/#{sub}"
        RSpec::Core::RakeTask.new(sub => spec_prereq) do |t|
        #RSpec::Core::RakeTask.new(sub) do |t|
          # the user might not have run rspec generator because they don't
          # actually need it, but without an ./.rspec they won't get color,
          # let's insist.
          t.rspec_opts = "--colour"

          # pattern directory name defaults to ./**/*_spec.rb, but has a more concise command line echo
          t.pattern = "#{atrium_spec}/#{sub}"
        end
      end
    end

    desc "Run all atrium:spec:* tasks"
    task :spec => directories_to_test.collect{|sym| "atrium:spec:#{sym}"}

    desc "Generate code coverage via rcov"
    RSpec::Core::RakeTask.new('rcov' => [spec_prereq, 'atrium:setup_test_app'].flatten.compact) do |t|
      t.rcov = true
      t.rcov_opts = %w{--rails --exclude osx\/objc,gems\/,spec\/}
      t.pattern = "#{atrium_spec}/**/*spec.rb"
    end

  end
rescue LoadError
  # This rescue pattern stolen from cucumber; rspec didn't need it before since
  # tasks only lived in rspec gem itself, but for Atrium since we're copying
  # these tasks into Atrium, we use the rescue so you can still run Atrium (without
  # these tasks) even if you don't have rspec installed.
  desc 'rspec rake tasks not available (rspec not installed)'
  task :spec do
    abort 'Rspec rake tasks  not available. Be sure to install rspec gems. '
  end
end
