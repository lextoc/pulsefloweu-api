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

  def create
    folder = current_user.folders.new(folder_params)
    folder.user = current_user
    authorize!(:create, folder)

    validate_object(folder)

    if folder.save
      folder_user = folder.folder_users.new(user: current_user, creator: current_user, role: :admin)
      authorize!(:create, folder_user)
      folder_user.save
    end

    render(json: folder)
  end

  def update
    folder = current_user.folders.find(params[:id])
    authorize!(:update, folder)
    folder.update(folder_params)
    render(json: folder)
  end

  def destroy
    folder = current_user.folders.find_by(id: params[:id])

    if folder.nil?
      render(json: { success: false, errors: ['Folder not found'] }.to_json, status: 404)
      return
    end

    authorize!(:destroy, folder)
    folder.destroy
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :project_id)
  end
end
