FactoryGirl.define do
  factory :user do
    name { [true, false].sample ? Faker::Name.unique.first_name : Faker::Name.unique.last_name }
    password              { "password" }
    password_confirmation { "password" }
  end
end
