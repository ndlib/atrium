# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :showcase, :class => 'Atrium::Showcase' do
    association :showcases, factory: :collection
    sequence(:tag) { |n| "tag-#{n}" }
    sequence(:sequence) { |n| n.to_i }
  end
end
