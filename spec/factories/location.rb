FactoryGirl.define do
  factory :location do
    name 'LocationTEST'
    longitude '15.9889981'
    latitude '45.8033957'
    revision 1
    ptv_location_id 'RPGJNQ614F27S5Q74WJ1G8QG6'
    address
    company
    custom_fields ['weight', 'height', 'test']
  end
end
