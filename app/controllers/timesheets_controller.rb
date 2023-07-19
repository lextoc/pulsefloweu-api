class TimesheetsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.timesheets.all
  end

  def show
    timesheet = current_user.timesheets.find(params[:id])
    render json: timesheet
  end

  def create
    timesheet = current_user.timesheets.create(timesheet_params)
    render json: timesheet
  end

  def update
    return unless optional_task_valid?

    timesheet = current_user.timesheets.find(params[:id])
    timesheet.update(timesheet_params)
    render json: timesheet
  end

  def destroy
    current_user.timesheets.destroy(params[:id])
  end

  private

  def timesheet_params
    params.require(:timesheet).permit(:start_date, :duration, :task_id)
  end
end
