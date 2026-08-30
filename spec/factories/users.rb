FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'Password@123' }
    password_confirmation { 'Password@123' }
  end
end