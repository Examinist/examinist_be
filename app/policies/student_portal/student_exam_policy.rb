class StudentPortal::StudentExamPolicy < ApplicationPolicy
  attr_reader :ip

  def initialize(context, record)
    @user = context.user
    @ip = context.ip
    @record = record
  end

  def index?
    true
  end

  def sixty_minutes_exams?
    @ip == ENV['IP_ADDRESS']
  end

  class Scope < Scope
    def initialize(context, scope)
      @user = context.user
      @scope = scope
    end

    def resolve
      @user.student_exams.includes(:exam)
    end
  end
end
