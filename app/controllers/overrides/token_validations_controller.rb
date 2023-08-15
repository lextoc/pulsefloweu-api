class Overrides::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  def validate_token
    # @resource will have been set by set_user_by_token concern
    if @resource
      avatar = { 'avatar' => @resource.avatar.attached? ? rails_blob_url(@resource.avatar) : nil }

      render(json: {
               success: true,
               data: JSON.parse(@resource.to_json).merge(avatar)
             })
    else
      render(json: {
               success: false,
               errors: ['Invalid login credentials']
             }, status: 401)
    end
  end
end
