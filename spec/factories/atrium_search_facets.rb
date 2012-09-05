# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_facet, :class => 'Atrium::Search::Facet' do
    association :collection
    sequence(:name) {|n| "Name #{n}" }
  end
end
