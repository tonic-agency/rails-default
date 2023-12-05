class KycOnboardingMailer < ApplicationMailer
  default from: 'megan@meganennis.dev'
  
  def account_verification_in_progress_email(kyc_onboarding, variables = {})
    @kyc_onboarding = kyc_onboarding || params[:kyc_onboarding]
    
    @name = variables.try(:[], :name) || @kyc_onboarding.try(:name)
    @account_url = variables.try(:[], :account_url) || @kyc_onboarding.try(:account_url)
    
    mail(to: variables[:email], subject: 'Your Farmbank account is currently being verified ✍🏽')
  end

end