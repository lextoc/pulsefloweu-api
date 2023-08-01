class Misc::TimeEntriesController < ApplicationController
  before_action :authenticate_user!

  def stop
    time_entries = current_user.time_entries.where(end_date: nil)
    stop_time_entries(time_entries)
    render(json: { success: true, data: time_entries }.to_json)
  end

  def running_timers
    time_entries = current_user.time_entries.where(end_date: nil).page(params[:page] || 1)
    running_timers_data = build_running_timers_data(time_entries)
    render(json: { success: true, data: running_timers_data, meta: pagination_info(time_entries) }.to_json)
  end

  private

  def stop_time_entries(time_entries)
    time_entries.each do |time_entry|
      authorize_and_update_time_entry(time_entry, end_date: Time.now.utc)
    end
  end

  def build_running_timers_data(time_entries)
    time_entries.map do |time_entry|
      authorize!(:read, time_entry)
      extra_fields = { 'task_name' => time_entry.task.name }
      JSON.parse(time_entry.to_json).merge(extra_fields)
    end
  end

  def authorize_and_update_time_entry(time_entry, attributes)
    authorize!(:update, time_entry)
    time_entry.assign_attributes(attributes)
    authorize!(:update, time_entry)
    validate_object(time_entry)
    time_entry.save
  end
end
