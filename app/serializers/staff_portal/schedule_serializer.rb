class StaffPortal::ScheduleSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title

  ####################### Show Details ############################
  attribute :exams, if: proc { |_record, params| params && params[:show_details] } do |object, params|
    StaffPortal::ExamSerializer.new(object.exams, params: { auto_grade: params[:auto_grade] }).to_j
  end
end
