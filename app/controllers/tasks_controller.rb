class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks.all.page(params[:page] || 1)
    tasks.each { |task| authorize!(:read, task) }
    render_data(tasks)
  end

  def show
    task = current_user.tasks.find(params[:id])
    authorize!(:read, task)
    render(json: { success: true, data: task }.to_json)
  end

  def timesheets
    timesheets = params[:active] ? active_timesheets : all_timesheets
    timesheets.each { |timesheet| authorize!(:read, timesheet) }
    render_data(timesheets)
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

  def active_timesheets
    current_user.timesheets.where(task_id: params[:id]).where(end_date: nil)
  end

  def all_timesheets
    current_user.timesheets.where(task_id: params[:id])
  end
end
