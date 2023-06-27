class StaffPortal::BusyLabPolicy < ApplicationPolicy
  def update?
    @user.admin?
  end

  def students?
    @user.admin?
  end

  def available_proctors?
    @user.admin?
  end
  
  class Scope < Scope
    def resolve
      @user.busy_labs
    end
  end
end