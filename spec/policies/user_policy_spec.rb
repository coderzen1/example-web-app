require 'rails_helper'

describe UserPolicy do
  subject { UserPolicy }

  permissions :index?, :new?, :create?, :edit?, :update?, :destroy?, :toggle_activation? do
    it "denies access if user is only admin" do
      expect(subject).not_to permit(User.new(role: 1))
    end

    it "grants access if user is an superadmin" do
      expect(subject).to permit(User.new(role: 0))
    end
  end
end
