class StaffPortal::TopicsController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_course, only: %i[index create update destroy]
  before_action :find_topic, only: %i[update destroy]
  #######
  # List Topics for a specific course
  # GET: /staff_portal/courses/:course_id/topics
  # Auth: Admin and Instructor
  #######
  def index
    render_response({ topics: StaffPortal::TopicSerializer.new(@course.topics).to_j }, :ok)
  end

  #######
  # Create Topic for a specific course
  # POST: /staff_portal/courses/:course_id/topics
  # Auth: Admin and Instructor
  #######
  def create
    topic = @course.topics.create!(create_topic_params)
    render_response({ topic: StaffPortal::TopicSerializer.new(topic).to_j }, :created)
  end

  #######
  # Update Topic for a specific course
  # PATCH: /staff_portal/courses/:course_id/topics/:id
  # Auth: Admin and Instructor
  #######
  def update
    @topic.update!(update_topic_params)
    render_response({ topic: StaffPortal::TopicSerializer.new(@topic).to_j }, :ok)
  end

  #######
  # Delete Topic for a specific course
  # DELETE: /staff_portal/courses/:course_id/topics/:id
  # Auth: Admin and Instructor
  #######
  def destroy
    @topic.destroy!
    render_response({ topic: StaffPortal::TopicSerializer.new(@topic).to_j }, :ok)
  end


  private

  def check_authorization_policy
    authorize([:staff_portal, Topic])
  end

  def find_course
    records = @current_user.assigned_courses
    @course = records.find(params[:course_id])
  end

  def create_topic_params
    params.permit(:name)
  end

  def find_topic
    records = policy_scope([:staff_portal, Topic])
    @topic = records.where(course: @course).find(params[:id])
  end

  def update_topic_params
    params.permit(:name)
  end
end
