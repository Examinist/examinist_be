class StaffPortal::StudentExamPolicy < ApplicationPolicy
  def index?
    # TODO: to be changed to true in control module
    @user.instructor? || @user.admin?
  end

  class Scope < Scope
    def initialize(user, scope, params)
      super(user, scope)
      @exam_id = params[:exam_id]
    end

    def resolve
      if @user.proctor?
        # TODO: to be changed later to get this exam properly from the collection of exams that the proctor will attend
        exam = Exam.find(@exam_id)
        exam.student_exams
      else
        @user.student_exams.where(exam_id: @exam_id).where(status: %i[pending_grading graded])
      end
    end
  end
end
