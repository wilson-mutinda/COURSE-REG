class Api::V1::NotificationsController < ApplicationController
  # fetch all_notifications
  def all_notifications
    begin
      notifications = Notification.order(created_at: :desc)
      if notifications.empty?
        render json: { error: "Empty List"}, status: :not_found
        return
      else
        info = notifications.map do |notification|
          email = notification.user.email
          phone = notification.user.email
        notification.as_json.merge({ email: email, phone: phone})
          
        end
        render json: info, status: :ok
      end
    rescue => e
      render json: { error: 'Something went wrong!', message: e.message }, status: :internal_server_error
    end
  end

  # update_notification
  def update_notification
    begin
      notification = Notification.find_by(id: params[:id])
      if notification
        updated_list = {}

        # action_param
        action_param = notification_params[:action].to_s
        if action_param.present?
          action_param = action_param
          updated_list[:action] = action_param
        end

        # message_param
        message_param = notification_params[:message].to_s
        if message_param.present?
          message_param = message_param
          updated_list[:message] = message_param
        end

        # read_param
        read_param = notification_params[:read].to_s
        if read_param.present?
          read_param = read_param
          updated_list[:read] = read_param
        end

        # update_notification
        updated_notification = notification.update(updated_list)
        if updated_notification
          render json: { message: "Notification updated"}, status: :ok
        else
          render json: { error: "Error updating notification", info: notification.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: { notification: "Notification not found!"}}, status: :not_found
      end
    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

  # privately hold notification_params
  private
  def notification_params
    params.require(:notification).permit(:user, :action, :message, :read)
  end
end
