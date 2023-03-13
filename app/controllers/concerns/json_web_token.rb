require 'jwt'

module JsonWebToken
  extend ActiveSupport::Concern

  def jwt_encode(payload, exp = 10.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Constants::SECRET_KEY)
  end

  def jwt_decode(token)
    body = JWT.decode(token, Constants::SECRET_KEY)[0]
    # Use HashWithIndifferentAccess to access the hash with string or symbol keys
    HashWithIndifferentAccess.new body
  rescue StandardError
    nil
  end
end
