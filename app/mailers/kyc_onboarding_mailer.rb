class KycOnboardingMailer < ApplicationMailer
  default from: ENV.fetch('DEFAULT_FROM_EMAIL')
  
  def account_verification_in_progress_email(kyc_onboarding, variables = {})
    @kyc_onboarding = kyc_onboarding || params[:kyc_onboarding]
    
    @name = variables.try(:[], :name) || @kyc_onboarding.try(:name)
    @account_url = variables.try(:[], :account_url) || @kyc_onboarding.try(:account_url)
    
    mail(to: variables[:email], subject: 'Your Farmbank account is currently being verified ✍🏽')
  end

  def account_verification_complete_email(kyc_onboarding, variables = {})
    @kyc_onboarding = kyc_onboarding || params[:kyc_onboarding]
    
    @name = variables.try(:[], :name) || @kyc_onboarding.try(:name)
    
    mail(to: variables[:email], subject: 'Welcome to Farmbank - Account Successfully Verified')
  end

  def account_verification_rejected_email(kyc_onboarding, variables = {})
    @kyc_onboarding = kyc_onboarding || params[:kyc_onboarding]
    
    @name = variables.try(:[], :name) || @kyc_onboarding.try(:name)
    
    mail(to: variables[:email], subject: 'Your Farmbank account verification was unsuccessful')
  end

  def account_verification_requires_info_email(kyc_onboarding, variables = {})
    @kyc_onboarding = kyc_onboarding || params[:kyc_onboarding]
    
    @name = variables.try(:[], :name) || @kyc_onboarding.try(:name)
    
    mail(to: variables[:email], subject: 'Action Required: Additional Information Needed for Your Farmbank Account')
  end

end