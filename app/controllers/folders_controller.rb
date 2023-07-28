class FoldersController < ApplicationController
  before_action :authenticate_user!

  def index
    folders = current_user.folders.all.page(params[:page] || 1)
    folders.each { |folder| authorize!(:read, folder) }
    render_data(folders)
  end

  def show
    folder = current_user.folders.find(params[:id])
    authorize!(:read, folder)
    render(json: { success: true, data: folder }.to_json)
  end

  def tasks
    tasks = current_user.tasks.where(folder_id: params[:id]).page(params[:page])
    tasks.each { |task| authorize!(:read, task) }
    render_data(tasks)
  end

  def create
    folder = current_user.folders.new(folder_params)
    folder.user = current_user
    authorize!(:create, folder)

    validate_object(folder)
    folder.save

    render(json: { success: true, data: folder }.to_json)
  end

  def update
    folder = current_user.folders.find(params[:id])
    authorize!(:update, folder)

    folder.assign_attributes(folder_params)
    authorize!(:update, folder)

    validate_object(folder)
    folder.save

    render(json: { success: true, data: folder }.to_json)
  end

  def destroy
    folder = current_user.folders.find_by(id: params[:id])
    authorize!(:destroy, folder)
    folder.destroy
    render(json: { success: true }.to_json)
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :project_id)
  end
end
