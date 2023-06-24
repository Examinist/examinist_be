class StudentPortal::StudentExamSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :grade, :status

  attribute :title do |object|
    object.exam.title
  end

  attribute :total_score do |object|
    object.exam.total_score
  end

  attribute :scheduled_date do |object|
    object.exam.starts_at
  end

  attribute :ends_at do |object|
    object.exam.ends_at
  end

  attribute :duration do |object|
    object.exam.duration
  end

  attribute :course do |object|
    StudentPortal::CourseSerializer.new(object.exam.course).to_j
  end

  attribute :busy_lab do |object|
    StudentPortal::BusyLabSerializer.new(object.assigned_busy_lab).to_j
  end

  attribute :answers, if: proc { |_record, params| params && params[:show_details] } do |object|
    StudentPortal::StudentAnswerSerializer.new(object.student_answers).to_j
  end
end