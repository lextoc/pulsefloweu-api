class Misc::TasksController < ApplicationController
  before_action :authenticate_user!

  def total_duration_of_timesheets
    timesheets = all_timesheets
    timesheets.each { |timesheet| authorize!(:read, timesheet) }
    render(json: get_total_duration_of_timesheets(timesheets))
  end

  private

  def get_total_duration_of_timesheets(timesheets)
    duration = 0
    timesheets.each do |timesheet|
      duration += ((timesheet.end_date.nil? ? Time.now.getutc.to_f : timesheet.end_date.to_f) -
        timesheet.start_date.to_f).to_i
    end
    duration
  end

  def all_timesheets
    current_user.timesheets.where(task_id: params[:id])
  end
end
