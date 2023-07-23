class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  protect_from_forgery unless: -> { request.format.json? }

  private

  rescue_from CanCan::AccessDenied do |exception|
    puts ''
    puts '----- ACCESS DENIED BY CANCAN -----'
    puts exception.inspect
    puts '-----------------------------------'
    puts ''
    render json: { success: false, errors: ['You are not authorized'] }.to_json, status: 403
  end

  def render_data(data)
    render json: {
      data:,
      meta: pagination_info(data)
    }.to_json
  end

  def pagination_info(data)
    {
      current_page: data.current_page,
      next_page: data.next_page,
      per_page: data.limit_value,
      prev_page: data.prev_page,
      total_pages: data.total_pages,
      total_count: data.total_count
    }
  end
end
