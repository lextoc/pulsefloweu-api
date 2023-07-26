class TimesheetsController < ApplicationController
  before_action :authenticate_user!

  def index
    timesheets = if params[:active]
                   current_user.timesheets.where(end_date: nil).page(params[:page] || 1)
                 else
                   current_user.timesheets.page(params[:page] || 1)
                 end
    render_data(timesheets)
  end

  def show
    timesheet = current_user.timesheets.find(params[:id])
    render(json: timesheet)
  end

  def stop
    timesheets = current_user.timesheets.where(end_date: nil).update_all(end_date: Time.now.utc)
    render(json: timesheets)
  end

  def create
    timesheet = current_user.timesheets.new(timesheet_params)
    timesheet.user = current_user
    authorize!(:create, timesheet)

    validate_object(timesheet)

    timesheet.save
    render(json: timesheet)
  end

  def update
    timesheet = current_user.timesheets.find(params[:id])
    timesheet.update(timesheet_params)
    render(json: timesheet)
  end

  def destroy
    current_user.timesheets.destroy(params[:id])
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:start_date, :end_date, :task_id, :folder_id)
  end
end
