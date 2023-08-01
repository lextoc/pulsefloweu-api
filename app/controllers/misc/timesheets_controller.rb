class Misc::TimesheetsController < ApplicationController
  before_action :authenticate_user!

  def timesheets
    from_date = Date.parse(params[:from])
    to_date = Date.parse(params[:to])
    folder_ids = params[:folder_ids]

    time_entries = fetch_time_entries(from_date, to_date, folder_ids)
    authorize_time_entries(time_entries)
    render_timesheets_response(from_date, to_date, time_entries)
  end

  private

  def fetch_time_entries(from_date, to_date, folder_ids)
    TimeEntry.joins(task: :folder)
             .where('folders.id IN (?) AND time_entries.start_date >= ? AND time_entries.end_date <= ?',
                    folder_ids, from_date, to_date)
             .page(params[:page] || 1)
  end

  def authorize_time_entries(time_entries)
    time_entries.each { |time_entry| authorize!(:read, time_entry) }
  end

  def render_timesheets_response(from_date, to_date, time_entries)
    render(json: { success: true, data: {
      from_date:,
      to_date:,
      time_entries:
    }, meta: pagination_info(time_entries) }.to_json)
  end
end
