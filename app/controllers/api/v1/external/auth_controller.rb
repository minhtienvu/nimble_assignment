class Api::V1::External::AuthController < Api::V1::External::ApplicationController
  include JsonWebToken

  skip_before_action :authenticate_request!, only: [:login]

  def login
    @user = User.find_by(email: params[:email])

    unless @user&.valid_password?(params[:password])
      return render_error(Constants::JSON_WEB_TOKEN[:authorization_error])
    end

    render json: { token: jwt_encode(user_id: @user.id) }
  end
end
