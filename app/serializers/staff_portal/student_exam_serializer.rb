class StaffPortal::StudentExamSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :status, :student_status

  attribute :student do |object|
    StaffPortal::StudentSerializer.new(object.student).to_j
  end

  attribute :partial_graded_questions do |object|
    object&.partial_graded_questions
  end

  attribute :total_graded_questions do |object|
    object&.student_answers&.size
  end

  attribute :partial_score do |object|
    object&.partial_score
  end

  attribute :total_score do |object|
    object&.total_score
  end

  ####################### Show Details ############################
  attribute :student_answers, if: proc { |_record, params| params && params[:show_details] } do |object|
    get_sorted_student_answers(object)
  end

  ####################### Methods ############################
  def self.get_sorted_student_answers(obj)
    sorted_records = obj.student_answers.joins(exam_question: :question_type).order('question_types.name ASC')
    StaffPortal::StudentAnswerSerializer.new(sorted_records).to_j
  end
end
