class StaffPortal::ExamSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :status, :duration, :total_score, :created_at

  attribute :scheduled_date do |object|
    object&.starts_at
  end

  attribute :creation_mode do |object|
    object&.is_auto ? 'Automatic' : 'Manual'
  end

  attribute :creator do |object|
    StaffPortal::StaffSerializer.new(object.staff).to_j
  end

  attribute :course do |object|
    StaffPortal::CourseSerializer.new(object.course).to_j
  end
  ####################### Show Details ############################
  attribute :exam_questions, if: proc { |_record, params| params && params[:show_details] } do |object|
    get_questions(object)
  end

  ####################### Methods ############################
  def self.get_questions(obj)
    exam_questions = []
    obj&.course&.question_types&.each do |type|
      records = obj&.exam_questions&.joins(question: :question_type)&.where(question_types: { id: type.id })
      exam_questions << { type.name.to_s => StaffPortal::ExamQuestionSerializer.new(records).to_j } if records.size.positive?
    end
    exam_questions
  end
end