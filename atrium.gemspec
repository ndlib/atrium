$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "atrium/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "atrium"
  s.version     = Atrium::VERSION
  s.authors     = [
    "Richard Johnson",
    "Jeremy Friesen",
    "Banu Lakshminarayanan",
    "Dan Brubaker-Horst"
  ]
  s.email       = [
    "jeremy.n.friesen"
  ]
  s.homepage    = "http://github.com/ndlib/atrium"
  s.summary     = "TODO: Summary of Atrium."
  s.description = "TODO: Description of Atrium."

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "jquery-rails"
  s.add_dependency "friendly_id"
  s.add_dependency 'ckeditor_rails'
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-given"
  s.add_development_dependency 'rspec-on-rails-matchers'
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "factory_girl_rails"
end
