class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    projects = current_user.projects.all.page(params[:page])
    render_data projects
  end

  def show
    project = current_user.projects.find(params[:id])
    render json: project
  end

  def create
    project = current_user.projects.create(project_params)
    render json: project
  end

  def update
    project = current_user.projects.find(params[:id])
    project.update(project_params)
    render json: project
  end

  def destroy
    current_user.projects.destroy(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
