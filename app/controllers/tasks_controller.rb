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
    timesheets = params[:active] ? active_timesheets : all_timesheets
    timesheets.each { |timesheet| authorize!(:read, timesheet) }
    if params[:total_duration]
      render(json: total_duration_of_timesheets)
      return
    end
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

  def active_timesheets
    current_user.timesheets.where(task_id: params[:id]).where(end_date: nil)
  end

  def all_timesheets
    current_user.timesheets.where(task_id: params[:id])
  end

  def total_duration_of_timesheets
    duration = 0
    all_timesheets.each do |timesheet|
      duration += ((timesheet.end_date.nil? ? Time.now.getutc.to_f : timesheet.end_date.to_f) -
        timesheet.start_date.to_f).to_i
    end
    duration
  end
end
