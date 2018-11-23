FactoryBot.define do
  factory :access_token do
    token { "MyString" }
    user { build :user }
  end
end
