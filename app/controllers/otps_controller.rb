class OtpsController < ApplicationController
 
  def resend_email
    @otp = Otp.find(params[:id])
    # TODO: Add error handling if OTP not found/already validated
    @otp.resend_email
  end

  def resend_mobile
    @otp = Otp.find(params[:id])
     # TODO: Add error handling if OTP not found/already validated
    @otp.resend_mobile
  end
end