FactoryBot.define do
  factory :todo do
    description { 'My to do' }
    due { 1.day.from_now }
    list
  end
end
