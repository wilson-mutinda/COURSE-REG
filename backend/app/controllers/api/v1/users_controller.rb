class Api::V1::UsersController < ApplicationController

  # create_user
  def create_user
    begin
      # user_params in request body
      # email_param
      email_param = user_params[:email].to_s
      if email_param.blank?
        render json: { errors: { email: "Email Cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        # email_format
        email_format = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
        unless email_param.match(email_format)
          render json: { errors: { email: "Invalid Email Format!"}}, status: :unprocessable_entity
          return
        end

        # email should not exist
        user_email = User.find_by(email: email_param)
        if user_email
          render json: { errors: { email: "Email Exists!"}}, status: :unprocessable_entity
          return
        end
      end

      # phone_param
      phone_param = user_params[:phone].to_s
      if phone_param.blank?
        render json: { errors: { phone: "Phone should Exist"}}, status: :unprocessable_entity
        return
      else
        # phone_format
        phone_format =  /\A(01|07)\d{8}\z/
        unless phone_param.match(phone_format)
          render json: { errors: { phone: "Invalid Phone Format!"}}, status: :unprocessable_entity
          return
        end

        # phone should not exist
        user_phone = User.find_by(phone: phone_param)
        if user_phone
          render json: { errors: { phone: "Phone Exists"}}, status: :unprocessable_entity
          return
        end
      end

      # password_param and password_confirmation_param
      password_param = user_params[:password]
      password_confirmation_param = user_params[:password_confirmation]
      if password_param.present? || password_confirmation_param.present?
        if !password_param || !password_confirmation_param
          render json: { errors: { password_confirmation: "Both Password fields are required!"}}, status: :unprocessable_entity
          return
        end

        # password_format
        unless password_param.match(/\d/) && password_param.match(/[A-Za-z]/)
          render json: { errors: { password: "Password should have both digits and alphabets"}}, status: :unprocessable_entity
          return
        end

        # password mismatch
        if password_param != password_confirmation_param
          render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
          return
        end

        # password length
        if password_param.length < 8
          render json: { errors: { password: "Password should have at least 8 characters"}}, status: :unprocessable_entity
          return
        end
      else
        render json: { errors: { password: "Password and confirmation are required!"}}, status: :unprocessable_entity
        return
      end

      # create_user
      created_user = User.create(
        email: email_param,
        phone: phone_param,
        password: password_param,
        password_confirmation: password_confirmation_param
      )
      if created_user.persisted?
        render json: { message: "User Created!"}, status: :created
      else
        render json: { error: "Error Creating User", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end

    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end    
  end

  # update_user
  def update_user
    begin
      user = User.find_by(id: params[:id])
      if user
        # user_flag
        user_flag = user_params[:flag].to_s
        if user_flag.present?
          user_flag = user_flag.to_s.gsub(/\s+/, '').downcase
        end

        # update_user
        if user.update(flag: user_flag)
          render json: { message: "User updated"}, status: :ok
        else
          render json: { error: "Error updating user", info: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "User not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # user_login
  def user_login
    begin
      email_param = params[:email].to_s
      password_param = params[:password]

      # check if user with the email exists
      user = User.find_by(email: email_param)
      if user
        auth = user.authenticate(password_param)
        if auth
          access_token=JsonWebToken.encode(user.id, user.flag, 30.minutes.from_now)
          refresh_token=JsonWebToken.encode(user.id, user.flag, 24.hours.from_now)
          UserMailer.welcome_email(user).deliver_now
          render json: { 
            message: "Login Successful",
            access_token: access_token,
            refresh_token: refresh_token,
            flag: user.flag,
            email: user.email,
            phone: user.phone
          }, status: :ok
        else
          render json: { errors: { password: "Invalid Password!"}}, status: :unauthorized
        end
      else
        render json: { errors: { email: "Email Not Found!"}}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # refresh_token
  def refresh_token
    begin
      header = request.headers['Authorization']
      if header
        refresh_token = header.split(' ').last
        decoded_token = JsonWebToken.decode(refresh_token)

        user_id = decoded_token['user_id']
        flag = decoded_token['flag']

        new_access_token = JsonWebToken.encode(user_id, flag, 30.minutes.from_now)
        new_refresh_token = JsonWebToken.encode(user_id, flag, 24.hours.from_now)

        render json: {
          message: "Token refreshed successfully",
          id: user_id,
          flag: flag,
          new_access_token: new_access_token,
          new_refresh_token: new_refresh_token

        }, status: :ok
      else
        render json: { error: "Token Needed"}, status: :unauthorized
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # send_reset_email
  def send_reset_email
    begin
      email_param = params[:email].to_s.gsub(/\s+/, '').downcase
      # check if the email user exists
      user = User.find_by(email: email_param)
      if user
        token = SecureRandom.hex(20)
        user.update_columns(
          reset_password_token: token,
          reset_sent_at: Time.now.utc
        )
        if user
          PasswordMailer.reset_password(user).deliver_now
          render json: { message: "Check Email to reset email!", token: token}, status: :ok
        else
          render json: { error: "Erorr Sending Email"}, status: :unauthorized
        end
      else
        render json: { errors: { resetEmail: "Email Does not exist"}}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # reset_email
  def reset_email
    begin
      # token_param
      token_param = params[:token]

      # password_param
      password_param = params[:password]
      # password_confirmation_param
      password_confirmation_param = params[:password_confirmation]

      # check if token user exists and if it is valid
      user = User.find_by(reset_password_token: token_param)
      if user && user.reset_sent_at > 2.hours.ago
        if password_param.present? || password_confirmation_param.present?
          if !password_param || !password_confirmation_param
            render json: { errors: { password_confirmation: "Both Password fields are required!"}}, status: :unprocessable_entity
            return
          end

          if password_param.present? && password_confirmation_param.present? && password_param != password_confirmation_param
            render json: { errors: { password_confirmation: "Password Mismatch!"}}, status: :unprocessable_entity
            return
          end

          if password_param.length < 8
            render json: { errors: { password: "Password should have at least 8 characters"}}, status: :unprocessable_entity
            return
          end

          unless password_param.match(/\d/) && password_param.match(/[A-Za-z]/)
            render json: { errors: { password: "Password should have both alphabets and digits"}}, status: :unprocessable_entity
            return
          end
        end

        # reset password_reset_token and password_sent_at to null
        user.reset_password_token = nil
        user.reset_sent_at = nil
        user.password = password_param
        user.password_confirmation = password_confirmation_param

        if user.save
          render json: { message: "Password reset successfully!"}, status: :ok
        else
          render json: { error: "Error reseting password", info: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Invalid Token"}, status: :unauthorized
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # user_params
  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation, :flag)
  end

end
