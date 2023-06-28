class StaffPortal::ExamPolicy < ApplicationPolicy
  attr_reader :ip

  def initialize(context, record)
    @user = context.user
    @ip = context.ip
    @record = record
  end

  def index?
    true
  end

  def show?
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

  def auto_generate?
    @user.instructor? || @user.admin?
  end

  def sixty_minutes_exams?
    @user.proctor? && @ip == ENV['IP_ADDRESS']
  end

  class Scope < Scope
    def initialize(context, scope, params)
      p context
      @user = context.user
      super(@user, scope)
      @action_name = params[:action_name]
      @course_id = params[:course_id]
    end

    def resolve
      return user.proctored_exams if user.proctor?

      records = if @action_name == 'index' && @user.admin?
                  @user.faculty.exams
                else
                  @user.courses_exams
                end
      records = records.where(course_id: @course_id) if @course_id.present?
      records
    end
  end
end
