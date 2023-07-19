class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  protect_from_forgery unless: -> { request.format.json? }

  private

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
