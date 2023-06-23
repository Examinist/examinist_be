class StudentPortal::StudentExamSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :grade, :status

  attribute :exam_id, if: proc { |_record, params| params && params[:list_exams] } do |object|
    object.exam.id
  end

  attribute :title, if: proc { |_record, params| params && params[:list_exams] } do |object|
    object.exam.title
  end

  attribute :total_score, if: proc { |_record, params| params && params[:list_exams] } do |object|
    object.exam.total_score
  end

  attribute :scheduled_date, if: proc { |_record, params| params && params[:list_exams] } do |object|
    object.exam.starts_at
  end

  attribute :ends_at, if: proc { |_record, params| params && params[:list_exams] } do |object|
    object.exam.ends_at
  end

  attribute :duration, if: proc { |_record, params| params && params[:list_exams] } do |object|
    object.exam.duration
  end

  attribute :course, if: proc { |_record, params| params && params[:list_exams] } do |object|
    StudentPortal::CourseSerializer.new(object.exam.course).to_j
  end

  attribute :busy_lab, if: proc { |_record, params| params && params[:list_exams] } do |object|
    StudentPortal::BusyLabSerializer.new(object.assigned_busy_lab).to_j
  end
end