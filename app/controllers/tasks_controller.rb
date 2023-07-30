class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks.all.page(params[:page] || 1)
    arr = []
    tasks.each do |task|
      authorize!(:read, task)

      extra_fields = { 'folder_name' => task.folder.name,
                       'project_name' => task.folder.project.name,
                       'project_id' => task.folder.project_id,
                       'active_time_entries' => JSON.parse(task.time_entries.where(end_date: nil).all.to_json) }

      arr << JSON.parse(task.to_json).merge(extra_fields)
    end

    render(json: { success: true, data: arr, meta: pagination_info(tasks) }.to_json)
  end

  def show
    task = current_user.tasks.find(params[:id])
    authorize!(:read, task)

    extra_fields = { 'folder_name' => task.folder.name,
                     'project_name' => task.folder.project.name,
                     'project_id' => task.folder.project_id,
                     'active_time_entries' => JSON.parse(task.time_entries.where(end_date: nil).all.to_json) }

    render(json: {
             success: true,
             data: JSON.parse(task.to_json).merge(extra_fields)
           })
  end

  def time_entries
    time_entries = params[:active] ? active_time_entries : all_time_entries

    arr = []
    time_entries.each do |time_entry|
      authorize!(:read, time_entry)

      extra_fields = { 'task_name' => time_entry.task.name,
                       'folder_name' => time_entry.folder.name,
                       'project_name' => time_entry.folder.project.name }
      arr << JSON.parse(time_entry.to_json).merge(extra_fields)
    end

    render(json: { success: true, data: arr, meta: pagination_info(time_entries) }.to_json)
  end

  def create
    task = current_user.tasks.new(task_params)
    task.user = current_user
    authorize!(:create, task)

    validate_object(task)
    task.save

    render(json: { success: true, data: task }.to_json)
  end

  def update
    task = current_user.tasks.find(params[:id])
    authorize!(:update, task)

    task.assign_attributes(task_params)
    authorize!(:update, task)

    validate_object(task)
    task.save

    render(json: { success: true, data: task }.to_json)
  end

  def destroy
    task = current_user.tasks.find_by(id: params[:id])
    authorize!(:destroy, task)
    task.destroy
    render(json: { success: true }.to_json)
  end

  private

  def task_params
    params.require(:task).permit(:name, :project_id, :folder_id)
  end

  def active_time_entries
    current_user.time_entries.where(task_id: params[:id]).where(end_date: nil).page(params[:page] || 1)
  end

  def all_time_entries
    current_user.time_entries.where(task_id: params[:id]).all.page(params[:page] || 1)
  end
end
