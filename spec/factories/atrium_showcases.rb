# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :showcase, :class => 'Atrium::Showcase' do
    association :showcases, factory: :collection
    sequence(:tag) { |n| "tag-#{n}" }
    sequence(:sequence) { |n| n.to_i }
  end

  factory(
    :collection_showcase,
    :class => 'Atrium::Showcase',
    :parent => :showcase
  ) do
    association :showcases, factory: :collection
  end

  factory(
    :exhibit_showcase,
    :class => 'Atrium::Showcase',
    :parent => :showcase
  ) do
    association :showcases, factory: :exhibit
  end
end
