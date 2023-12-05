# Preview all emails at http://localhost:3000/rails/mailers/kyc_onboarding_mailer
class KycOnboardingMailerPreview < ActionMailer::Preview

  def account_verification_in_progress_email
    KycOnboardingMailer.account_verification_in_progress_email(kyc_onboarding: KycOnboarding.submitted.first, variables: KycOnboarding.submitted.first.email_variables)
  end
end
