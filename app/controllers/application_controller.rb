class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  protect_from_forgery unless: -> { request.format.json? }

  class InvalidObject < StandardError; end

  protected

  def configure_permitted_parameters
    added_attrs = %i[username first_name last_name avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
  end

  private

  rescue_from CanCan::AccessDenied do |exception|
    handle_exception(exception, 403, 'You are not authorized')
  end

  rescue_from ActionController::ParameterMissing do |exception|
    handle_exception(exception, 400, 'You made a bad request')
  end

  rescue_from InvalidObject do |exception|
    handle_exception(exception, 400, 'You made a bad request')
  end

  def handle_exception(exception, status, message)
    puts('')
    puts(exception.inspect)
    puts('')
    render(json: { success: false, errors: [message] }.to_json, status:)
  end

  def validate_object(object)
    raise(InvalidObject) unless object.valid?
  end

  def render_data(data)
    render(json: {
      success: true,
      data:,
      meta: pagination_info(data)
    }.to_json)
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
