class StaffPortal::CourseGroupPolicy < ApplicationPolicy
  def index?
    @user.instructor? || @user.admin?
  end
end
