class Users::SessionsController < Devise::SessionsController
  layout "application"
  
  def create
    super do |user|
      return redirect_to app_home_path if user&.kyc_onboarding&.state == KycOnboarding::STATES[:submitted][:id]
      
      if user.persisted?
        if feature_flag?('2FA_ENABLED') && user&.login_otp.present? && user&.kyc_onboarding&.phone.present?
          @otp = user.login_otp
          @otp.generate_otp!
          @otp.mobile = user.kyc_onboarding.phone
          message = "Enter the one-time-password (OTP) below to log in to Farmbank.\n\n #{@otp.value} \n\nFor your account safety please do not share this with anyone."
          @otp.send_sms(message)
        end
      end
    end
  end

  def destroy
    user = current_user
    if user&.login_otp.present?
      user.login_otp.generate_otp!
      user.login_otp.update!(validated_at: nil)
    end
    super
  end
end