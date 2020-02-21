FactoryBot.define do
  factory :article do
    sequence(:text) { |n| "text #{n}" }
    sequence(:preview) { |n| "preview #{n}" }
    sequence(:title) { |n| "title #{n}" }
  end
end
