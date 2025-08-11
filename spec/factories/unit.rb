FactoryBot.define do
  factory :unit do
    sequence(:name) { |n| "sampleUnit#{n}"}
    sequence(:position_x)
    sequence(:position_y)
  end
end