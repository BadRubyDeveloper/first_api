FactoryBot.define do
  factory :token do
    user { nil }
    token { "MyString" }
    expired { false }
  end
end
