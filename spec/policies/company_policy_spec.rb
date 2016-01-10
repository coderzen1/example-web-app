require 'rails_helper'

describe CompanyPolicy do
  let(:company) { create(:company) }
  let(:company2) { create(:company) }
  let(:admin) { create(:user, role: 1, company: company) }
  let(:superadmin) { create(:user, role: 0) }

  subject { CompanyPolicy }

  permissions :index?, :new?, :create?, :destroy? do
    it "denies access if user is only admin" do
      expect(subject).not_to permit(admin)
    end

    it "grants access if user is an superadmin" do
      expect(subject).to permit(superadmin)
    end
  end

  permissions :update?, :edit? do
    it "let admin change only his company" do
      expect(subject).to permit(admin, company)
    end

    it "denies access to admin to change other company" do
      expect(subject).not_to permit(admin, company2)
    end

    it "grants access if user is an superadmin" do
      expect(subject).to permit(superadmin)
    end
  end
end
