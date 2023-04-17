class StaffPortal::QuestionPolicy < ApplicationPolicy
  def index?
    @user.instructor? || @user.admin?
  end

  def create?
    @user.instructor? || @user.admin?
  end

  def update?
    @user.instructor? || @user.admin?
  end

  def destroy?
    @user.instructor? || @user.admin?
  end
  
  class Scope < Scope
    def resolve
      @user.course_questions
    end
  end
end