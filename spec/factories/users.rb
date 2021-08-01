FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :name do |n|
    "User#{n}"
  end

  factory :user do
    name
    email
    password { "1234" }
  end
end
