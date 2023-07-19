class FoldersController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.folders.all
  end

  def show
    folder = current_user.folders.find(params[:id])
    render json: folder
  end

  def create
    folder = current_user.folders.create(folder_params)
    render json: folder
  end

  def update
    folder = current_user.folders.find(params[:id])
    folder.update(folder_params)
    render json: folder
  end

  def destroy
    current_user.folders.destroy(params[:id])
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :project_id)
  end
end
