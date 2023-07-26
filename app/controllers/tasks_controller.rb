class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks.page(params[:page] || 1)
    tasks.each { |task| authorize!(:read, task) }
    render_data(tasks)
  end

  def show
    task = current_user.tasks.find(params[:id])
    authorize!(:read, task)
    render(json: task)
  end

  def timesheets
    timesheets = if params[:active]
                   current_user.timesheets.where(task_id: params[:id]).where(end_date: nil).page(params[:page] || 1)
                 else
                   current_user.timesheets.where(task_id: params[:id]).page(params[:page] || 1)
                 end
    timesheets.each { |timesheet| authorize!(:read, timesheet) }
    render_data(timesheets)
  end

  def create
    task = current_user.tasks.new(task_params)
    task.user = current_user
    authorize!(:create, task)

    validate_object(task)

    if task.save
      task_user = task.task_users.new(user: current_user, creator: current_user, role: :admin)
      authorize!(:create, task_user)
      task_user.save
    end

    render(json: task)
  end

  def update
    task = current_user.tasks.find(params[:id])
    authorize!(:update, task)
    task.update(task_params)
    render(json: task)
  end

  def destroy
    task = current_user.tasks.find_by(id: params[:id])

    if task.nil?
      render(json: { success: false, errors: ['Task not found'] }.to_json, status: 404)
      return
    end

    authorize!(:destroy, task)
    task.destroy
  end

  private

  def task_params
    params.require(:task).permit(:name, :project_id, :folder_id)
  end
end
