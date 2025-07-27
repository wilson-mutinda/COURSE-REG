class Api::V1::StudentsController < ApplicationController
  # create_student
  def create_student
    begin
      # user_params
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

      # student_params
      # f_name_param
      f_name_param = student_params[:first_name].to_s.gsub(/\s+/, '').downcase
      if f_name_param.blank?
        render json: { errors: { first_name: "Firstname required!"}}, status: :unprocessable_entity
        return
      else
        f_name_param = f_name_param.to_s.gsub(/\s+/, '').capitalize
      end

      # l_name_param
      l_name_param = student_params[:last_name].to_s.gsub(/\s+/, '').downcase
      if l_name_param.blank?
        render json: { errors: { last_name: "Lastname required!"}}, status: :unprocessable_entity
        return
      else
        l_name_param = l_name_param.to_s.gsub(/\s+/, '').capitalize
      end

      # create_user
      created_user = User.create(
        email: email_param,
        phone: phone_param,
        password: password_param,
        password_confirmation: password_confirmation_param,
        flag: 'student'
      )
      if created_user
        Notification.create(
          user: created_user,
          action: 'student_created',
          message: "Student #{f_name_param} #{l_name_param} created account.",
          read: false
        )
        # create_student
        created_student = Student.create(
          first_name: f_name_param,
          last_name: l_name_param,
          user_id: created_user.id
        )
        if created_student
          render json: { message: "Student Created!"}, status: :created
        else
          render json: { error: "Error creating student!", info: created_student.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Error Creating User", info: created_user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # fetch single_student
  def single_student
    begin
      student = Student.find_by(id: params[:id])
      if student
        email = student.user.email
        phone = student.user.phone
        info = student.as_json(except: [:created_at, :updated_at, :user_id]).merge({ email: email, phone: phone})
        render json: info, status: :ok
      else
        render json: { error: "Student Not Found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong", message: e.message }, status: :internal_server_error
    end
  end

  # fetch all_students
  def all_students
    begin
      students = Student.all
      if students.empty?
        render json: { error: "Empty List!"}, status: :not_found
        return
      else
        info = students.map do |student|
          email = student.user.email
          phone = student.user.phone

        student.as_json(except: [:created_at, :updated_at, :user_id]).merge({ email: email, phone: phone})          
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong", message: e.message }, status: :internal_server_error
    end
  end

  # update_student
  def update_student
    begin
      student = Student.find_by(id: params[:id])
      if student
        # associated_user
        user = student.user
        # get params in the request body only
        # user_params
        # email_param
        email_param = user_params[:email].to_s
        if email_param.present?
          # email_format
          email_format = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
          unless email_param.match(email_format)
            render json: { errors: { email: "Invalid Email Format!"}}, status: :unprocessable_entity
            return
          end

          # email should not exist
          user_email = User.find_by(email: email_param)
          if user_email && user_email.id != user.id
            render json: { errors: { email: "Email Exists!"}}, status: :unprocessable_entity
            return
          end
        end

        # phone_param
        phone_param = user_params[:phone].to_s
        if phone_param.present?
          # phone_format
          phone_format =  /\A(01|07)\d{8}\z/
          unless phone_param.match(phone_format)
            render json: { errors: { phone: "Invalid Phone Format!"}}, status: :unprocessable_entity
            return
          end

          # phone should not exist
          user_phone = User.find_by(phone: phone_param)
          if user_phone && user_phone.id != user.id
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

        # student_params
        # f_name_param
        f_name_param = student_params[:first_name].to_s
        if f_name_param.present?
          f_name_param = f_name_param.to_s.gsub(/\s+/, '').capitalize
        end

        # l_name_param
        l_name_param = student_params[:last_name].to_s
        if l_name_param.present?
          l_name_param = l_name_param.to_s.gsub(/\s+/, '').capitalize
        end

        # update_user
        updated_user = user.update(
          email: email_param,
          phone: phone_param,
          password: password_param,
          password_confirmation: password_confirmation_param
        )
        if updated_user
          # create notification
          Notification.create(
            user: student.user,
            action: 'student_updated',
            message: "Student #{student.first_name} #{student.last_name} updated details.",
            read: false
          )
          # update_student
          updated_student = student.update(
            first_name: f_name_param,
            last_name: l_name_param
          )
          if updated_student
            render json: { message: "Student Updated"}, status: :ok
          else
            render json: { error: "Error Updating Student!"}, status: :unprocessable_entity
          end
        else
          render json: { error: "Error updating user", info: updated_user.error.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "Student not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # delete_student
  def delete_student
    begin
      student = Student.find_by(id: params[:id])
      if student
        user = student.user
        email = user.email
        # delete student first
        student.destroy
        user.destroy
        render json: { message: "Student with '#{email}' deleted successfully"}, status: :ok
      else
        render json: { error: "Student not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # privately hold user_params and student_params
  private
  def user_params
    params.require(:user).permit(:email, :phone, :password, :password_confirmation, :flag)
  end

  def student_params
    params.require(:student).permit(:first_name, :last_name, :user_id)
  end
end
