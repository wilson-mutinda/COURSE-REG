class Api::V1::CoursesController < ApplicationController

  before_action :get_user_id
  before_action :authorize_admin, except: [:all_courses, :single_course]
  before_action :authorize_admin_or_student, only: [:single_course, :all_courses]

  # create_course
  def create_course
    begin
      # name_param
      name_param = course_params[:name].to_s
      if name_param.blank?
        render json: { errors: { name: "Name cannot be blank!"}}, status: :unprocessable_entity
        return
      else
        name_param = name_param.to_s.strip.titleize
      end

      # create_course
      created_course = Course.create(
        user_id: @current_user_id,
        name: name_param
      )
      if created_course
        render json: { message: "Course created successfully"}, status: :created
      else
        render json: { error: "Error creating course!", info: created_course.errors.full_messages }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end    
  end

  # view single_course
  def single_course
    begin
      course = Course.find_by(id: params[:id])
      if course
        email = course.user.email
        flag = course.user.flag
        phone = course.user.phone
        info = course.as_json(except: [:created_at, :updated_at, :user_id]).merge({ email: email, phone: phone, flag: flag})
        render json: info, status: :ok
      else
        render json: { error: "Course not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end    
  end

  # view all_courses
  def all_courses
    begin
      courses = Course.all
      if courses.empty?
        render json: { error: "Empty list!"}, status: :not_found
        return
      else
        info = courses.map do |course|
          email = course.user.email
          phone = course.user.phone
          flag = course.user.flag
        course.as_json(except: [:created_at, :updated_at, :user_id]).merge({ email: email, phone: phone, flag: flag})          
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # update_course
  def update_course
    begin
      course = Course.find_by(id: params[:id])
      if course
        # name_param
        name_param = course_params[:name].to_s.gsub(/\s+/, '').downcase
        if name_param.present?
          name_param = name_param.to_s.strip.titleize
        end
        # update_course
        updated_course = course.update(
          name: name_param
        )
        if updated_course
          render json: { message: "Course Updated!"}, status: :ok
        else
          render json: { error: "Error Updating Course"}, status: :unprocessable_entity
        end
      else
        render json: { error: "Course Not Found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end    
  end

  # delete_course
  def delete_course
    begin
      course = Course.find_by(id: params[:id])
      if course
        course_name = course.name
        course.destroy
        render json: { message: "Course '#{course_name}' deleted successfully!"}, status: :ok
      else
        render json: { error: "Course not found!"}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # privately hold course_params
  private

  def get_user_id
    header = request.headers['Authorization']
    if header
      token = header.split(' ').last
      begin
        decoded_token = JsonWebToken.decode(token)
        @current_user_id = decoded_token[:user_id]
        @current_user_flag = decoded_token[:flag]
      rescue JWT::DecodeError
        render json: { error: "Invalid token" }, status: :unauthorized
      end
    else
      render json: { error: "Token Required!"}, status: :unauthorized
    end
  end

  def authorize_admin
    unless @current_user_flag == "admin"
      render json: { error: "Unauthorized: Admins only"}, status: :unauthorized
      return
    end
  end

  def authorize_admin_or_student
    unless ["admin", "student"].include?(@current_user_flag)
      render json: { error: "Unauthorized: Students and admins only"}, status: :unauthorized
      return
    end
  end

  def course_params
    params.require(:course).permit(:name, :user_id)
  end
end
