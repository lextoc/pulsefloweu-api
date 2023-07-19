class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    tasks = current_user.tasks.page(params[:page] || 1)
    render_data tasks
  end

  def show
    task = current_user.tasks.find(params[:id])
    render json: task
  end

  def create
    task = current_user.tasks.create(task_params)
    render json: task
  end

  def update
    task = current_user.tasks.find(params[:id])
    task.update(task_params)
    render json: task
  end

  def destroy
    current_user.tasks.destroy(params[:id])
  end

  private

  def task_params
    params.require(:task).permit(:name, :project_id, :folder_id)
  end
end
