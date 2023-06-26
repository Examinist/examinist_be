class StaffPortal::ScheduleSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title

  ####################### Show Details ############################
  attribute :exams, if: proc { |_record, params| params && params[:show_details] } do |object|
    StaffPortal::ExamSerializer.new(object.exams).to_j
  end
end
