class TimeEntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    time_entries = params[:active] ? active_time_entries : all_time_entries
    time_entries.each { |time_entry| authorize!(:read, time_entry) }
    render_data(time_entries)
  end

  def show
    time_entry = current_user.time_entries.find(params[:id])
    authorize!(:read, time_entry)
    render(json: { success: true, data: time_entry }.to_json)
  end

  def create
    time_entry = current_user.time_entries.new(time_entry_params)
    time_entry.user = current_user
    authorize!(:create, time_entry)

    validate_object(time_entry)
    time_entry.save

    render(json: { success: true, data: time_entry }.to_json)
  end

  def update
    time_entry = current_user.time_entries.find(params[:id])
    authorize!(:update, time_entry)

    time_entry.assign_attributes(time_entry_params)
    authorize!(:update, time_entry)

    validate_object(time_entry)
    time_entry.save

    render(json: { success: true, data: time_entry }.to_json)
  end

  def destroy
    time_entry = current_user.time_entry.find_by(id: params[:id])
    authorize!(:destroy, time_entry)
    time_entry.destroy
    render(json: { success: true }.to_json)
  end

  private

  def time_entry_params
    params.require(:time_entry).permit(:start_date, :end_date, :task_id, :folder_id)
  end

  def active_time_entries
    current_user.time_entries.where(end_date: nil).all.page(params[:page] || 1)
  end

  def all_time_entries
    current_user.time_entries.all.page(params[:page] || 1)
  end
end
