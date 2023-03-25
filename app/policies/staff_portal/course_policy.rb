class StaffPortal::CoursePolicy < ApplicationPolicy
  def index?
    @user.instructor? || @user.admin?
  end

  def show?
    @user.instructor? || @user.admin?
  end

  class Scope < Scope
    def resolve
      return Course.all.where(faculty: @user.faculty) if @user.admin?

      @user.assigned_courses
    end
  end
end
