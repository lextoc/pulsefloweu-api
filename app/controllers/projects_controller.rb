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
    # Create the project.
    project = current_user.projects.new(project_params)
    project.user = current_user
    authorize!(:create, project)

    validate_object(project)

    # Also create the project user relation.
    if project.save
      project_user = project.project_users.new(user: current_user, creator: current_user, role: :admin)
      authorize!(:create, project_user)
      project.save
    end

    render(json: project)
  end

  def update
    project = current_user.projects.find(params[:id])
    authorize!(:update, project)
    project.update(project_params)
    render(json: project)
  end

  def destroy
    project = current_user.projects.find_by(id: params[:id])

    if project.nil?
      render(json: { success: false, errors: ['Project not found'] }.to_json, status: 404)
      return
    end

    authorize!(:destroy, project)
    project.destroy
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
