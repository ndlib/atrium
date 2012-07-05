# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :notrify => 'true', :cli => '--color', :spec_paths => 'test_support/spec' do
  watch(%r|^app/(.*)\.rb|) { |m|
    "test_support/spec/#{m[1]}_spec.rb"
  }
  watch(%r|^test_support/spec/(.*)_spec\.rb|)
  watch('test_support/spec/spec_helper.rb') { 'test_support/spec' }
end