# Preview all emails at http://localhost:3000/rails/mailers/kyc_onboarding_mailer
class KycOnboardingMailerPreview < ActionMailer::Preview

  def account_verification_in_progress_email
    KycOnboardingMailer.with(kyc_onboarding: KycOnboarding.first).account_verification_in_progress_email
  end
end
