class StudentPortal::CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      @user.courses
    end
  end
end
