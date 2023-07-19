class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  include DeviseTokenAuth::Concerns::SetUserByToken

  respond_to :json

  protect_from_forgery unless: -> { request.format.json? }
end
