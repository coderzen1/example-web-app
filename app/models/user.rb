class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :rememberable, :recoverable, :validatable
  enum role: [:superadmin, :admin]
  belongs_to :company
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def show_active_status
    self.active ? I18n.t("users_active_yes") : I18n.t("users_active_no")
  end

  def toggle_activation_message
    self.active? ? I18n.t("users_toggle_activation_link_deactivate") : I18n.t("users_toggle_activation_link_activate")
  end
end
