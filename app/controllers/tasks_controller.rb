class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_task, only: %i[show update destroy]

  def index
    tasks = current_user.tasks.all.page(params[:page] || 1)
    task_data = build_task_data(tasks)
    render(json: { success: true, data: task_data, meta: pagination_info(tasks) }.to_json)
  end

  def show
    task_data = build_task_data([@task])
    render(json: { success: true, data: task_data.first }.to_json)
  end

  def time_entries
    time_entries = params[:active] ? active_time_entries : all_time_entries
    object = build_time_entries_data(time_entries)
    render(json: { success: true, data: object, meta: pagination_info(time_entries) }.to_json)
  end

  def create
    task = build_new_task(task_params)
    render(json: { success: true, data: task }.to_json)
  end

  def update
    update_task(@task, task_params)
    render(json: { success: true, data: @task }.to_json)
  end

  def destroy
    destroy_task(@task)
    render(json: { success: true }.to_json)
  end

  private

  def task_params
    params.require(:task).permit(:name, :project_id, :folder_id)
  end

  def find_task
    @task = current_user.tasks.find(params[:id])
  end

  def build_task_data(tasks)
    tasks.map do |task|
      authorize!(:read, task)
      extra_fields = {
        'folder_name' => task.folder.name,
        'project_name' => task.folder.project.name,
        'project_id' => task.folder.project_id,
        'active_time_entries' => JSON.parse(task.time_entries.where(end_date: nil).all.to_json)
      }
      task.as_json.merge(extra_fields)
    end
  end

  def build_time_entries_data(time_entries)
    object = {}

    time_entries.each do |time_entry|
      date_key = time_entry.start_date.strftime('%F')

      object[date_key] ||= {
        time_entries: [],
        data: get_data_for_date(time_entry.start_date)
      }

      authorize!(:read, time_entry)

      extra_fields = {
        'task_name' => time_entry.task.name,
        'folder_name' => time_entry.folder.name,
        'project_name' => time_entry.folder.project.name
      }

      object[date_key][:time_entries] << time_entry.as_json.merge(extra_fields)
    end

    object
  end

  def active_time_entries
    current_user.time_entries.where(task_id: params[:id]).where(end_date: nil).page(params[:page] || 1)
  end

  def all_time_entries
    current_user.time_entries.where(task_id: params[:id]).all.page(params[:page] || 1)
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

  def build_new_task(attributes)
    task = current_user.tasks.new(attributes)
    task.user = current_user
    authorize!(:create, task)

    validate_object(task)
    task.save

    task
  end

  def update_task(task, attributes)
    authorize!(:update, task)

    task.assign_attributes(attributes)
    authorize!(:update, task)

    validate_object(task)
    task.save
  end

  def destroy_task(task)
    authorize!(:destroy, task)
    task.destroy
  end
end
