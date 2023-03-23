class StaffPortal::CoursePolicy < ApplicationPolicy
  def index?
    @user.instructor?
  end

  class Scope < Scope
    def resolve
      @user.courses
    end
  end
end
