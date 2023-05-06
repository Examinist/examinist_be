class StaffPortal::ExamPolicy < ApplicationPolicy
  def index?
    user.instructor? || user.admin?
  end

  def show?
    user.instructor? || user.admin?
  end

  def create?
    user.instructor? || user.admin?
  end

  def update?
    user.instructor? || user.admin?
  end

  def destroy?
    user.instructor? || user.admin?
  end

  def auto_generate?
    user.instructor? || user.admin?
  end

  class Scope < Scope
    def initialize(user, scope, params)
      super(user, scope)
      @action_name = params[:action_name]
      @course_id = params[:course_id]
    end

    def resolve
      records = if @action_name == 'index' && user.admin?
                  user.faculty.exams
                else
                  user.courses_exams
                end
      records = records.where(course_id: @course_id) if @course_id.present?
      records
    end
  end
end
