class TimeEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    time_entries = params[:active] ? active_time_entries : all_time_entries
    time_entries = time_entries.where(task_id: params[:task_id]) if params[:task_id].present?
    object = build_time_entries_data(time_entries)
    render(json: { success: true, data: object, meta: pagination_info(time_entries) }.to_json)
  end

  def show
    time_entry = find_time_entry_by_id(params[:id])
    render(json: { success: true, data: time_entry }.to_json)
  end

  def create
    time_entry = build_new_time_entry(time_entry_params)
    render(json: { success: true, data: time_entry }.to_json)
  end

  def update
    time_entry = find_time_entry_by_id(params[:id])
    update_time_entry(time_entry, time_entry_params)
    render(json: { success: true, data: time_entry }.to_json)
  end

  def destroy
    time_entry = find_time_entry_by_id(params[:id])
    destroy_time_entry(time_entry)
    render(json: { success: true }.to_json)
  end

  private

  def time_entry_params
    params.require(:time_entry).permit(:start_date, :end_date, :task_id, :folder_id)
  end

  def active_time_entries
    current_user.time_entries.recent_first.where(end_date: nil).page(params[:page] || 1)
  end

  def all_time_entries
    current_user.time_entries.recent_first.page(params[:page] || 1)
  end

  def build_time_entries_data(time_entries)
    object = {}

    sorted_time_entries = time_entries.sort_by { |time_entry| time_entry.start_date }.reverse

    sorted_time_entries.each do |time_entry|
      start_date_formatted = time_entry.start_date.strftime('%F')
      object[start_date_formatted] ||= {
        time_entries: [],
        data: get_data_for_date(time_entry.start_date)
      }

      store_time_entry_data(object, time_entry)
    end

    object
  end

  def store_time_entry_data(object, time_entry)
    authorize!(:read, time_entry)

    extra_fields = {
      'task_name' => time_entry.task.name,
      'folder_name' => time_entry.folder.name,
      'project_name' => time_entry.folder.project.name,
      'project_id' => time_entry.folder.project.id
    }

    date_key = time_entry.start_date.strftime('%F')
    object[date_key][:time_entries] << time_entry_data(time_entry).merge(extra_fields)
  end

  def time_entry_data(time_entry)
    time_entry.as_json
  end

  def find_time_entry_by_id(id)
    current_user.time_entries.find(id)
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def render_not_found
    render(json: { success: false, error: 'Time entry not found' }.to_json, status: :not_found)
  end

  def build_new_time_entry(attributes)
    time_entry = current_user.time_entries.new(attributes)
    time_entry.user = current_user
    authorize!(:create, time_entry)

    validate_object(time_entry)
    time_entry.save

    time_entry
  end

  def update_time_entry(time_entry, attributes)
    authorize!(:update, time_entry)

    time_entry.assign_attributes(attributes)
    authorize!(:update, time_entry)

    validate_object(time_entry)
    time_entry.save
  end

  def destroy_time_entry(time_entry)
    authorize!(:destroy, time_entry)
    time_entry.destroy
  end

  def get_data_for_date(date)
    time_entries = TimeEntry.where(start_date: date.beginning_of_day..date.end_of_day)
    total_duration = time_entries.sum do |entry|
      entry.end_date ? (entry.end_date - entry.start_date).to_i : (Time.now - entry.start_date).to_i
    end
    total_time_entries = time_entries.count

    {
      total_duration:,
      total_time_entries:
    }
  end
end
