class OtpsController < ApplicationController

  def validate_user_otp
    @otp = current_user.mobile_otp

  end
 
  def resend_email
    @otp = Otp.find(params[:id])
    # TODO: Add error handling if OTP not found/already validated
    @otp.resend_email
  end

  def resend_mobile
    @otp = Otp.find(params[:id])
     # TODO: Add error handling if OTP not found/already validated
    @otp.resend_sms
  end
end