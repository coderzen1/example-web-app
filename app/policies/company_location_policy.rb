class CompanyLocationPolicy < ApplicationPolicy


  def index?
    user.superadmin? || user.company == record
  end

  def new?
    user.superadmin? || user.company == record
  end

  def create?
    user.superadmin? || user.company == record
  end

  def edit?
    user.superadmin? || user.company == record
  end

  def update?
    user.superadmin? || user.company == record
  end

  def destroy?
    user.superadmin? || user.company == record
  end

  def refresh_token?
    user.superadmin? || user.company == record
  end
end
