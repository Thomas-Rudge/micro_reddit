FactoryGirl.define do
  factory :user do
    name                  { Faker::Name.unique.first_name.gsub(/[^\w-]+/, "") }
    password              { "password" }
    password_confirmation { "password" }
  end
end
