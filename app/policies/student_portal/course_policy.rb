class StudentPortal::CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.enrolled_courses
    end
  end
end
