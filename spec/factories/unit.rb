FactoryBot.define do
  factory :unit do
    sequence(:name) { |n| "sampleUnit#{n}" }
    position_x { 10.0 }
    position_y { 11.0 }
  end
end
