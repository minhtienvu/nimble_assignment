class Api::V1::External::ApplicationController < ActionController::API
  include JsonWebToken

  before_action :authenticate_request!, :current_user

  def render_error(message)
    render json: {
      message: message
    }
  end

  private

  def decoded_header
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    jwt_decode(header)
  end

  def authenticate_request!
    return render json: { error: Constants::JSON_WEB_TOKEN[:permission_denied] } unless decoded_header
  end

  def current_user
    @current_user ||= User.find_by(id: decoded_header['user_id']) if decoded_header
  end
end
