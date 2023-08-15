class Overrides::PasswordsController < DeviseTokenAuth::PasswordsController
  private

  # In case allow_other_host doesn't work, uncommenting this might fix it.
  # def resource_params
  #   params.permit(:email, :reset_password_token, :config, :redirect_url)
  # end

  def redirect_options
    {
      allow_other_host: true
    }
  end
end
