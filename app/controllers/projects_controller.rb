class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_project, only: %i[show folders update destroy]
  before_action :authorize_projects, only: %i[index show folders]

  def index
    render_projects(current_user.projects.page(params[:page]))
  end

  def show
    render(json: { success: true, data: @project }.to_json)
  end

  def folders
    render_projects(@project.folders.page(params[:page]))
  end

  def create
    project = build_new_project(project_params)
    render(json: { success: true, data: project }.to_json)
  end

  def update
    update_project(@project, project_params)
    render(json: { success: true, data: @project }.to_json)
  end

  def destroy
    destroy_project(@project)
    render(json: { success: true }.to_json)
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def find_project
    @project = current_user.projects.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def authorize_projects
    current_user.projects.each { |project| authorize!(:read, project) }
  end

  def build_new_project(attributes)
    project = current_user.projects.new(attributes)
    project.user = current_user
    authorize!(:create, project)

    validate_object(project)
    project.save

    project
  end

  def update_project(project, attributes)
    authorize!(:update, project)

    project.assign_attributes(attributes)
    authorize!(:update, project)

    validate_object(project)
    project.save
  end

  def destroy_project(project)
    authorize!(:destroy, project)
    project.destroy
  end

  def render_projects(projects)
    projects.each { |project| authorize!(:read, project) }
    render(json: { success: true, data: projects, meta: pagination_info(projects) }.to_json)
  end

  def render_not_found
    render(json: { success: false, error: 'Project not found' }.to_json, status: :not_found)
  end
end
