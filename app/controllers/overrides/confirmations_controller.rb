class Overrides::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
  def new
    @email = params[:email]
    @user = User.find_by(email: @email)

    if @user && @user.confirmed_at.nil?
      @user.send_confirmation_instructions({
                                             client_config: params[:config_name]
                                           })
      render(status: 200, json: {
        email: @email,
        message: 'Your request has been received. A new confirmation email has been sent.'
      }.to_json)
    elsif @user && @user.confirmed_at.present?
      render(status: 200, json: {
        email: @email,
        message: 'This account has already been confirmed.'
      }.to_json)
    else
      render(status: 404, json: {
        email: @email,
        message: 'No user account exists for this email.'
      }.to_json)
    end
  end

  private

  def redirect_options
    {
      allow_other_host: true
    }
  end
end
