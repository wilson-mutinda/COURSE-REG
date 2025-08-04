class Api::V1::PaymentsController < ApplicationController

  def create_payment
    begin
      # Save payment record first
      @payment = Payment.create!(
        course_name: params[:course_name],
        cost: params[:cost],
        user_phone: params[:user_phone],
        status: 'pending'
      )

      mpesa = MpesaService.new
      stk_response = mpesa.stk_push(
        params[:user_phone],
        params[:cost],
        @payment.id.to_s,
        "Payment for #{params[:course_name]}"
      )

      if stk_response["ResponseCode"] == "0"
        render json: { message: "STK push sent successfully", payment: @payment }, status: :ok
      else
        render json: { error: "M-Pesa Error", response: stk_response }, status: :bad_request
      end

    rescue => e
      render json: { error: "Something went wrong!", message: e.message }, status: :internal_server_error
    end
  end

def mpesa_callback
  data = JSON.parse(request.body.read)

  result = data['Body']['stkCallback']

  if result['ResultCode'] == 0
    amount = result['CallbackMetadata']['Item'].find { |i| i['Name'] == 'Amount' }['Value']
    phone = result['CallbackMetadata']['Item'].find { |i| i['Name'] == 'PhoneNumber' }['Value']

    # Update your payment record
    Payment.where(user_phone: phone).last&.update(status: 'paid', amount_paid: amount)
  else
    Rails.logger.info("M-Pesa payment failed: #{result['ResultDesc']}")
  end

  head :ok
end


end
