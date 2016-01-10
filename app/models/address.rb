class Address < ActiveRecord::Base
  validates :street, presence: true
  validates :city, presence: true
end
