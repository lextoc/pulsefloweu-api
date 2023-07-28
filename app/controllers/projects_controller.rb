class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    projects = current_user.projects.all.page(params[:page])
    projects.each { |project| authorize!(:read, project) }
    render_data(projects)
  end

  def show
    project = current_user.projects.find(params[:id])
    authorize!(:read, project)
    render(json: { success: true, data: project }.to_json)
  end

  def folders
    folders = current_user.folders.where(project_id: params[:id]).page(params[:page])
    folders.each { |folder| authorize!(:read, folder) }
    render_data(folders)
  end

  def create
    project = current_user.projects.new(project_params)
    project.user = current_user
    authorize!(:create, project)

    validate_object(project)
    project.save

    render(json: { success: true, data: project }.to_json)
  end

  def update
    project = current_user.projects.find(params[:id])
    authorize!(:update, project)

    project.assign_attributes(project_params)
    authorize!(:update, project)

    validate_object(project)
    project.save

    render(json: { success: true, data: project }.to_json)
  end

  def destroy
    project = current_user.projects.find_by(id: params[:id])
    authorize!(:destroy, project)
    project.destroy
    render(json: { success: true }.to_json)
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
