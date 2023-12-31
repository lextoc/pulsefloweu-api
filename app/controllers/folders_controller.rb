class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_folder, only: %i[show update destroy]
  before_action :authorize_folders, only: %i[index]
  before_action :authorize_folder, only: %i[show]

  def index
    folders = current_user.folders.oldest_first.page(params[:page])
    folders = folders.where(project_id: params[:project_id]) if params[:project_id]
    render_data(folders)
  end

  def show
    render(json: { success: true, data: @folder }.to_json)
  end

  def create
    folder = build_new_folder(folder_params)
    render(json: { success: true, data: folder }.to_json)
  end

  def update
    update_folder(@folder, folder_params)
    render(json: { success: true, data: @folder }.to_json)
  end

  def destroy
    destroy_folder(@folder)
    render(json: { success: true }.to_json)
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :project_id)
  end

  def find_folder
    @folder = current_user.folders.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_not_found
  end

  def authorize_folders
    current_user.folders.each { |folder| authorize!(:read, folder) }
  end

  def authorize_folder
    authorize!(:read, @folder)
  end

  def build_new_folder(attributes)
    folder = current_user.folders.new(attributes)
    folder.user = current_user
    authorize!(:create, folder)

    validate_object(folder)
    folder.save

    folder
  end

  def update_folder(folder, attributes)
    authorize!(:update, folder)

    folder.assign_attributes(attributes)
    authorize!(:update, folder)

    validate_object(folder)
    folder.save
  end

  def destroy_folder(folder)
    authorize!(:destroy, folder)
    folder.destroy
  end

  def render_data(data)
    data.each { |record| authorize!(:read, record) }
    render(json: { success: true, data:, meta: pagination_info(data) }.to_json)
  end

  def render_not_found
    render(json: { success: false, error: 'Folder not found' }.to_json, status: :not_found)
  end
end
