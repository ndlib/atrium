guard 'rspec', :cli => '--color --format nested' do
  if RUBY_PLATFORM =~ /linux/
    require 'libnotify'
    notification :libnotify 
  end
  if RUBY_PLATFORM =~ /darwin/
    require 'ruby_gntp'
    notification :ruby_gntp
  end
  watch('spec/spec_helper.rb') {
    'spec'
  }
  watch('config/routes.rb') {
    'spec/routing'
  }
  watch('app/controllers/atrium/application_controller.rb')  {
    'spec/controllers'
  }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^spec/\w*/atrium/.+_spec\.rb$})

  watch(%r{^app/(.+)\.rb$}) { |m|
    "spec/#{m[1]}_spec.rb"
  }

  watch(%r{^app/(.*)(\.erb)$}) { |m|
    "spec/#{m[1]}#{m[2]}_spec.rb"
  }

  watch(%r{^lib/(.+)\.rb$}) { |m|
    "spec/lib/#{m[1]}_spec.rb"
  }

  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| [
    "spec/routing/#{m[1]}_routing_spec.rb",
    "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
    "spec/acceptance/#{m[1]}_spec.rb"
  ]}
end
