class OtpsController < ApplicationController
  
  def validate_user_otp
    @otp = current_user.login_otp

    if @otp.validated_at.present?
      redirect_to app_home_path
    end

    if request.post?
      values = otp_params.values_at(:value_1, :value_2, :value_3, :value_4, :value_5, :value_6).join
      if @otp.validate_otp(values)
        welcome = params[:welcome].present? ? true : false
        if welcome
          redirect_to app_home_path(welcome: true)
        else
          redirect_to app_home_path
        end
      end 
    end
      
  end
 
  def resend_email
    @otp = Otp.find(params[:id])

    @otp.assign_attributes(otp_params)

    @otp.resend_email
  end

  def resend_mobile
    @otp = Otp.find(params[:id])
    
    @otp.assign_attributes(otp_params)

    @otp.resend_sms
  end

  private 
  def otp_params
    params.require(:otp).permit(
      :value_1,
      :value_2,
      :value_3,
      :value_4,
      :value_5,
      :value_6,
      :email,
      :mobile,
    )

  end
end