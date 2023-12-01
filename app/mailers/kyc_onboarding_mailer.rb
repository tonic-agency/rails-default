class KycOnboardingMailer < ApplicationMailer
  default from: 'megan@meganennis.dev'
  
  def account_verification_in_progress_email(kyc_onboarding)
    @kyc_onboarding = kyc_onboarding || params[:kyc_onboarding]
    
    @user = @kyc_onboarding.user
    @account_url = Rails.application.routes.url_helpers.app_home_url(:host => Rails.env.staging? ? 'farmbank.toniclabs.ltd' : request.host_with_port)
    
    mail(to: @user.email, subject: 'Your Farmbank account is currently being verified ✍🏽')
  end

end