class StaffPortal::StudentExamPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.admin? || user.instructor?
  end

  def update?
    user.admin? || user.instructor?
  end

  def permitted_attributes_for_update
    return [:student_status] if user.proctor?

    [{ student_answers_attributes: %i[id score] }]
  end

  class Scope < Scope
    def initialize(user, scope, params)
      super(user, scope)
      @exam_id = params[:exam_id]
    end

    def resolve
      if @user.proctor?
        exam = @user.proctored_exams.find(@exam_id)
        exam.student_exams
      else
        @user.student_exams.where(exam_id: @exam_id).where(status: %i[pending_grading graded])
      end
    end
  end
end
