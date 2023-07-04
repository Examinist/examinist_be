class StaffPortal::SchedulesController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_schedule, only: %i[show update destroy]

  #######
  # List Schedules
  # GET: /staff_portal/schedules
  # Auth: Admin and Instructor
  #######
  def index
    records = policy_scope([:staff_portal, Schedule])
    render_response({ schedules: StaffPortal::ScheduleSerializer.new(records.order(updated_at: :desc)).to_j }, :ok)
  end

  #######
  # Show Schedule
  # GET: /staff_portal/schedules/:id
  # Auth: Admin and Instructor
  #######
  def show
    render_response({ schedule: StaffPortal::ScheduleSerializer.new(@schedule, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Create Schedule
  # POST: /staff_portal/schedules
  # Auth: Admin
  #######
  def create
    schedule = Schedule.schedule_bulk_exams(create_schedule_params)
    render_response({ schedule: StaffPortal::ScheduleSerializer.new(schedule, params: { show_details: true }).to_j }, :created)
  end

  #######
  # Update Schedule
  # PATCH: /staff_portal/schedules/:id
  # Auth: Admin
  #######
  def update
    @schedule.update!(update_schedule_params)
    render_response({ schedule: StaffPortal::ScheduleSerializer.new(@schedule, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Delete Schedule
  # DELETE: /staff_portal/schedules/:id
  # Auth: Admin
  #######
  def destroy
    @schedule.destroy!
    render_response({ schedule: StaffPortal::ScheduleSerializer.new(@schedule, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Generate Schedule Automaticalliy
  # POST: /staff_portal/schedules/auto_generate
  # Auth: Admin and Instructor
  #######
  def auto_generate
    schedule = Schedule.generate_schedule(auto_generate_schedule_params)
    render_response({ schedule: StaffPortal::ScheduleSerializer.new(schedule, params: { show_details: true, auto_grade: true }).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, Schedule])
  end

  def find_schedule
    records = policy_scope([:staff_portal, Schedule])
    @schedule = records.find(params[:id])
  end

  def create_schedule_params
    params.permit(
      :title, { exams: [:id, :_force, :starts_at,
                        { busy_labs_attributes: %i[lab_id] }] }
    ).merge(faculty_id: @current_user.faculty_id)
  end

  def update_schedule_params
    params.permit(
      :title, { exams_attributes: [:id, :_force, :starts_at,
                                   { busy_labs_attributes: %i[id _destroy lab_id] }] }
    )
  end

  def auto_generate_schedule_params
    params.permit(
      :title, { exam_ids: [] }, :schedule_from, :schedule_to, { holiday_dates: [] }, { exam_week_days: [] },
      :exam_starting_time, { lab_ids: [] }
    ).merge(faculty_id: @current_user.faculty_id)
  end
end
