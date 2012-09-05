# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection, :class => 'Atrium::Collection' do
    sequence(:url_slug) {|n| "path-to-#{n}" }
    sequence(:title) {|n| "Title #{n}" }
  end
end
