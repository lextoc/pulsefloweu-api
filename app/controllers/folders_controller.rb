class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_folder, only: %i[show update destroy tasks]
  before_action :authorize_folders, only: %i[index]
  before_action :authorize_folder, only: %i[show tasks]

  def index
    render_data(current_user.folders.page(params[:page]))
  end

  def show
    render(json: { success: true, data: @folder }.to_json)
  end

  def tasks
    tasks = @folder.tasks.page(params[:page])
    tasks.each do |task| authorize!(:read, task) end
    tasks_data = build_task_data(tasks)
    render(json: { success: true, data: tasks_data, meta: pagination_info(tasks) }.to_json)
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

  def build_task_data(tasks)
    tasks.map do |task|
      authorize!(:read, task)
      extra_fields = {
        'total_duration_of_time_entries' => task.total_duration_of_time_entries,
        'active_time_entries' => JSON.parse(task.time_entries.where(end_date: nil).all.to_json)
      }
      JSON.parse(task.to_json).merge(extra_fields)
    end
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
