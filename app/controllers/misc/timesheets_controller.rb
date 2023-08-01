class Misc::TimesheetsController < ApplicationController
  before_action :authenticate_user!

  def timesheets_per_day
    from_date = Date.parse(params[:from])
    to_date = Date.parse(params[:to])
    folder_ids = params[:folder_ids]

    @time_entries = fetch_time_entries(from_date, to_date, folder_ids)
    authorize_time_entries(@time_entries)
    timesheets_data = group_time_entries_by_date(@time_entries)

    render_timesheets_response(from_date, to_date, timesheets_data, 'day')
  end

  def timesheets_per_week
    from_date = Date.parse(params[:from])
    to_date = Date.parse(params[:to])
    folder_ids = params[:folder_ids]

    @time_entries = fetch_time_entries(from_date, to_date, folder_ids)
    authorize_time_entries(@time_entries)
    timesheets_data = group_time_entries_by_week(@time_entries)

    render_timesheets_response(from_date, to_date, timesheets_data, 'week')
  end

  private

  def fetch_time_entries(from_date, to_date, folder_ids)
    TimeEntry.joins(task: :folder)
             .where('folders.id IN (?) AND time_entries.start_date >= ? AND time_entries.end_date <= ?',
                    folder_ids, from_date.beginning_of_day, to_date.end_of_day)
  end

  def authorize_time_entries(time_entries)
    time_entries.each { |time_entry| authorize!(:read, time_entry) }
  end

  def group_time_entries_by_date(time_entries)
    timesheets_data = {}

    time_entries.each do |time_entry|
      date_key = time_entry.start_date.strftime('%F')
      timesheets_data[date_key] ||= { time_entries: [], total_duration: 0 }
      timesheets_data[date_key][:time_entries] << {
        id: time_entry.id,
        start_date: time_entry.start_date,
        end_date: time_entry.end_date,
        task_name: time_entry.task.name
      }
      timesheets_data[date_key][:total_duration] += time_entry_duration(time_entry)
    end

    timesheets_data
  end

  def group_time_entries_by_week(time_entries)
    timesheets_data = {}

    time_entries.each do |time_entry|
      week_start = time_entry.start_date.beginning_of_week
      date_key = week_start.strftime('%F')
      timesheets_data[date_key] ||= { time_entries: [], total_duration: 0 }
      timesheets_data[date_key][:time_entries] << {
        id: time_entry.id,
        start_date: time_entry.start_date,
        end_date: time_entry.end_date,
        task_name: time_entry.task.name
      }
      timesheets_data[date_key][:total_duration] += time_entry_duration(time_entry)
    end

    timesheets_data
  end

  def time_entry_duration(time_entry)
    return 0 if time_entry.end_date.nil?

    (time_entry.end_date - time_entry.start_date).to_i
  end

  def render_timesheets_response(from_date, to_date, timesheets_data, view_type)
    render(json: { success: true, data: {
      from_date: from_date.to_s,
      to_date: to_date.to_s,
      time_entries: timesheets_data,
      view_type:
    } }.to_json)
  end
end
