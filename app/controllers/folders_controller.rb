class FoldersController < ApplicationController
  before_action :authenticate_user!

  def index
    folders = current_user.folders.all.page(params[:page] || 1)
    render_data(folders)
  end

  def show
    folder = current_user.folders.find(params[:id])
    render(json: folder)
  end

  def create
    folder = current_user.folders.new(folder_params)
    folder.user = current_user
    ap(folder)
    validate_object(folder)
    folder.save
    render(json: folder)
  end

  def update
    folder = current_user.folders.find(params[:id])
    folder.update(folder_params)
    render(json: folder)
  end

  def destroy
    current_user.folders.destroy(params[:id])
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :project_id)
  end
end
