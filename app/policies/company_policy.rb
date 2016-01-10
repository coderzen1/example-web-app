class CompanyPolicy < ApplicationPolicy
  def index?
    user.superadmin?
  end

  def new?
    user.superadmin?
  end

  def create?
    user.superadmin?
  end

  def edit?
    user.superadmin? || user.company == record
  end

  def update?
    user.superadmin? || user.company == record
  end

  def destroy?
    user.superadmin?
  end
end
