class TimesheetsController < ApplicationController
  before_action :authenticate_user!

  def index
    timesheets = params[:active] ? active_timesheets : all_timesheets
    timesheets.each { |timesheet| authorize!(:read, timesheet) }
    render_data(timesheets)
  end

  def show
    timesheet = current_user.timesheets.find(params[:id])
    authorize!(:read, timesheet)
    render(json: { success: true, data: timesheet }.to_json)
  end

  def stop
    timesheets = current_user.timesheets.where(end_date: nil).update_all(end_date: Time.now.utc)
    timesheets.each { |timesheet| authorize!(:update, timesheet) }
    render(json: timesheets)
  end

  def create
    timesheet = current_user.timesheets.new(timesheet_params)
    timesheet.user = current_user
    authorize!(:create, timesheet)

    validate_object(timesheet)
    timesheet.save

    render(json: { success: true, data: timesheet }.to_json)
  end

  def update
    timesheet = current_user.timesheets.find(params[:id])
    authorize!(:update, timesheet)

    timesheet.assign_attributes(timesheet_params)
    authorize!(:update, timesheet)

    validate_object(timesheet)
    timesheet.save

    render(json: { success: true, data: timesheet }.to_json)
  end

  def destroy
    timesheet = current_user.timesheet.find_by(id: params[:id])
    authorize!(:destroy, timesheet)
    timesheet.destroy
    render(json: { success: true }.to_json)
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:start_date, :end_date, :task_id, :folder_id)
  end

  def active_timesheets
    current_user.timesheets.where(end_date: nil)
  end

  def all_timesheets
    current_user.timesheets
  end
end
