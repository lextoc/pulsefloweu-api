class Overrides::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
  private

  def redirect_options
    {
      allow_other_host: true
    }
  end
end
