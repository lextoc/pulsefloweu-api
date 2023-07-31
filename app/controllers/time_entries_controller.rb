class TimeEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    time_entries = params[:active] ? active_time_entries : all_time_entries

    object = {}

    # Create dates with arrays.
    time_entries.each do |time_entry|
      object.store(time_entry.start_date.strftime('%F'), {
                     time_entries: [],
                     data: get_data_for_date(time_entry.start_date)
                   })
    end

    # Store time entries in the right date array.
    time_entries.each do |time_entry|
      authorize!(:read, time_entry)

      extra_fields = { 'task_name' => time_entry.task.name,
                       'folder_name' => time_entry.folder.name,
                       'project_name' => time_entry.folder.project.name }

      object[time_entry.start_date.strftime('%F')][:time_entries]
        .push(JSON.parse(time_entry.to_json)
        .merge(extra_fields))
    end

    render(json: { success: true, data: object, meta: pagination_info(time_entries) }.to_json)
  end

  def show
    time_entry = current_user.time_entries.find(params[:id])
    authorize!(:read, time_entry)
    render(json: { success: true, data: time_entry }.to_json)
  end

  def create
    time_entry = current_user.time_entries.new(time_entry_params)
    time_entry.user = current_user
    authorize!(:create, time_entry)

    validate_object(time_entry)
    time_entry.save

    render(json: { success: true, data: time_entry }.to_json)
  end

  def update
    time_entry = current_user.time_entries.find(params[:id])
    authorize!(:update, time_entry)

    time_entry.assign_attributes(time_entry_params)
    authorize!(:update, time_entry)

    validate_object(time_entry)
    time_entry.save

    render(json: { success: true, data: time_entry }.to_json)
  end

  def destroy
    time_entry = current_user.time_entries.find_by(id: params[:id])
    authorize!(:destroy, time_entry)
    time_entry.destroy
    render(json: { success: true }.to_json)
  end

  private

  def time_entry_params
    params.require(:time_entry).permit(:start_date, :end_date, :task_id, :folder_id)
  end

  def active_time_entries
    current_user.time_entries.where(end_date: nil).all.page(params[:page] || 1)
  end

  def all_time_entries
    current_user.time_entries.all.page(params[:page] || 1)
  end

  def get_data_for_date(date)
    total_duration = 0
    total_time_entries = 0

    TimeEntry.where(start_date: date.beginning_of_day..date.end_of_day).each do |time_entry|
      total_time_entries += 1
      total_duration += ((time_entry.end_date ? time_entry.end_date.to_f : DateTime.now.to_f) - time_entry.start_date.to_f).to_i
    end

    {
      total_duration:,
      total_time_entries:
    }
  end
end
