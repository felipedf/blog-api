FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "My Title #{n}" }
    content { "MyContent" }
    sequence(:slug) { |n| "my-slug-#{n}" }
  end
end
