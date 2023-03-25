class StudentPortal::CoursePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  class Scope < Scope
    def resolve
      @user.enrolled_courses
    end
  end
end
