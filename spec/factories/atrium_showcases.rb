# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection_showcase, :class => 'Atrium::Showcase' do
    association :showcases, factory: :collection
    sequence(:tag) { |n| "tag-#{n}" }
    sequence(:sequence) { |n| n.to_i }
  end

  factory :exhibit_showcase, :class => 'Atrium::Showcase' do
    association :showcases, factory: :exhibit
    sequence(:tag) { |n| "tag-#{n}" }
    sequence(:sequence) { |n| n.to_i }
  end
end
