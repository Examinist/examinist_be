class StaffPortal::SchedulePolicy < ApplicationPolicy
  def index?
    user.admin? || user.instructor?
  end

  def show?
    user.admin? || user.instructor?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def auto_generate?
    user.admin? || user.instructor?
  end

  class Scope < Scope
    def resolve
      user.schedules
    end
  end
end
