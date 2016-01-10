FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test-user-#{n}@example.com"
    end
    password "12345678"
    company
  end
end
