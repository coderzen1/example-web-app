class Company < ActiveRecord::Base
  mount_uploader :logo, LogoUploader
  belongs_to :address
  has_many :users
  has_many :locations, dependent: :destroy
  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :locations, allow_destroy: true
  validates :name, presence: true
  validates :token, presence: true
  validates :language, presence: true
  def full_address
    "#{address.street} #{address.number} #{address.city} #{address.zip_code}"
  end
end
