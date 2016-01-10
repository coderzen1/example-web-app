class Location < ActiveRecord::Base

  belongs_to :company
  belongs_to :address
  has_many :arrivals, dependent: :destroy

  accepts_nested_attributes_for :address

  before_create :generate_unique_tokens

  validates :show_token, uniqueness: true
  validates :edit_token, uniqueness: true
  validates :name, presence: true

  scope :persisted, -> { where.not(id: nil) }

  def refresh_token(token_type)
    return unless token_type.in?(['show', 'edit'])

    token_type == 'show' ? refresh_show_token : refresh_edit_token
    save
  end

  def full_address
    "#{address.street} #{address.number} #{address.city} #{address.zip_code}"
  end

  private

  def refresh_show_token
    self.show_token = generate_token
    refresh_show_token if Location.exists?(show_token: self.show_token)
  end

  def refresh_edit_token
    self.edit_token = generate_token
    refresh_edit_token if Location.exists?(edit_token: self.edit_token)
  end

  def generate_token
    SecureRandom.urlsafe_base64(24)
  end

  def generate_unique_tokens
    refresh_show_token
    refresh_edit_token
  end

end
