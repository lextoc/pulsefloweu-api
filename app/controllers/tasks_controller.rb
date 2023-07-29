class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks.all.page(params[:page] || 1)
    # tasks.each { |task| authorize!(:read, task) }
    # render_data(tasks)
    arr = []
    tasks.each do |task|
      authorize!(:read, task)

      new_field = { 'folder_name' => task.folder.name, 'project_name' => task.folder.project.name }
      arr << JSON.parse(task.to_json).merge(new_field)
    end

    render(json: { success: true, data: arr, meta: pagination_info(tasks) }.to_json)
  end

  def show
    task = current_user.tasks.find(params[:id])
    authorize!(:read, task)
    render(json: { success: true, data: task }.to_json)
  end

  def time_entries
    time_entries = params[:active] ? active_time_entries : all_time_entries
    time_entries.each { |time_entry| authorize!(:read, time_entry) }
    render_data(time_entries)
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
