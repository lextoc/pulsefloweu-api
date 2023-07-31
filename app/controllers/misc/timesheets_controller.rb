class Misc::TimesheetsController < ApplicationController
  before_action :authenticate_user!

  def timesheets
    arr = []

    from_date = Date.parse(params[:from])
    to_date = Date.parse(params[:to])
    folders = Folder.where(id: params[:folder_ids])

    folders.each do |folder|
      folder.tasks.each do |task|
        task.time_entries.each do |time_entry|
          arr << time_entry if time_entry.start_date >= from_date && time_entry.end_date <= to_date
        end
      end
    end

    render(json: { success: true, data: {
      from_date: params[:from],
      to_date: params[:to],
      time_entries: arr
    } }.to_json)
  end
end
