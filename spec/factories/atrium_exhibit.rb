# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exhibit, :class => 'Atrium::Exhibit' do
    association :collection
    sequence(:set_number) {|n| n.to_i }
  end
end
