class SessioinsController < ApplicationController
  begin
    def google_auth
      user_info = request.env['omniauth.auth']
      user = User.find_or_create_by(email: user_info['info']['email']) do |u|
        u.name = user_info['info']['name']
        u.password = SecureRandom.hex(10)
      end
      token = JsonWebToken.encode(user.id, 30.minutes.from_now)
      redirect_to "http://127.0.0.1:5173/oauth-success?token=#{token}", allow_other_host: true
    end
  rescue => e
    render json: { error: "Error Signing In", message: e.message }, status: :internal_server_error
  end
end
