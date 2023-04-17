class StaffPortal::QuestionTypeSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id
  
  ####################### Show Details ############################
  attributes :name, :easy_weight, :medium_weight, :hard_weight, :is_deletable, if: proc { |_record, params| params && params[:show_details] }
  attribute :ratio, if: proc { |_record, params| params && params[:template_details] }
end
