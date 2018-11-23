FactoryBot.define do
  factory :user do
    sequence(:login) {|i| "LoginName #{i}" }
    name { "MyString" }
    url { "MyString" }
    avatar_url { "MyString" }
    provider { "MyString" }
  end
end
