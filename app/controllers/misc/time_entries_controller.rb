class Misc::TimeEntriesController < ApplicationController
  before_action :authenticate_user!

  def stop
    time_entries = current_user.time_entries.where(end_date: nil)

    time_entries.each do |time_entry|
      authorize!(:update, time_entry)

      time_entry.assign_attributes(end_date: Time.now.utc)
      authorize!(:update, time_entry)

      time_entry.save
    end

    render(json: { success: true, data: time_entries }.to_json)
  end
end
