class Arrival < ActiveRecord::Base
  belongs_to :location
  enum vehicle_types: ['mg-car', 'mg-transporter', 'mg-truck-7.5t', 'mg-truck-11.99t', 'mg-truck-40t', 'mg-trailer-truck']
  validates :vehicle_type, presence: true
end
