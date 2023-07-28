class Misc::TasksController < ApplicationController
  before_action :authenticate_user!

  private

  def all_time_entries
    current_user.time_entries.where(task_id: params[:id])
  end
end
