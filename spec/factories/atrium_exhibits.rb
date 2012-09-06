# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exhibit, :class => 'Atrium::Exhibit' do
    association :collection
    sequence(:label) {|n| "Label #{n}" }
    sequence(:set_number) {|n| n.to_i }
  end
end
