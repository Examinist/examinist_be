class StaffPortal::BusyLabPolicy < ApplicationPolicy
  def update?
    @user.admin?
  end

  def students?
    @user.admin?
  end

  def available_proctors?
    @user.admin?
  end
  
  class Scope < Scope
    def initialize(user, scope, params)
      super(user, scope)
      @exam_id = params[:exam_id]
    end

    def resolve
      @user.faculty.exams.find(@exam_id).busy_labs
    end
  end
end