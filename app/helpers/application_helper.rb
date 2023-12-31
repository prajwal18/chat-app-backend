module ApplicationHelper
  @@secret_key = 'MyNameIsKhanAndIAmATerrorist'

  def encode_token(payload)
    JWT.encode(payload, @@secret_key)
  end

  def decoded_token
    header = request.headers['Authorization']

    return unless header

    token = header.split(' ')[1]
    begin
      JWT.decode(token, @@secret_key)
    rescue JWT::DecodeError
      nil
    end
  end

  def current_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    User.find_by(id: user_id)
  end

  def authorized
    return if !!current_user

    render json: { message: 'Please log in' }, status: :unauthorized
  end
end
