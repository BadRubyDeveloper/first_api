FactoryBot.define do
  factory :item do
    user
    name { FFaker::Lorem.word }
  end
end
