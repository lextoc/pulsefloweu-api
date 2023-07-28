class Misc::TasksController < ApplicationController
  before_action :authenticate_user!

  def total_duration_of_time_entries
    time_entries = all_time_entries
    time_entries.each { |time_entry| authorize!(:read, time_entry) }
    render(json: get_total_duration_of_time_entries(time_entries))
  end

  private

  def get_total_duration_of_time_entries(time_entries)
    duration = 0
    time_entries.each do |time_entry|
      duration += ((time_entry.end_date.nil? ? Time.now.getutc.to_f : time_entry.end_date.to_f) -
        time_entry.start_date.to_f).to_i
    end
    duration
  end

  def all_time_entries
    current_user.time_entries.where(task_id: params[:id])
  end
end
