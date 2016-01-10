FactoryGirl.define do
  factory :company do
    name "New Company"
    token "1234-5678-abcd"
    dashboard_colors ['rgb(1, 2, 3)', 'rgb(1, 4, 4)', 'rgb(1, 3, 5)']
    language "English"
    address
  end
end
