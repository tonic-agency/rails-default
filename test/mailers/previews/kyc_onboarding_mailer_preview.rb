# Preview all emails at http://localhost:3000/rails/mailers/kyc_onboarding_mailer
class KycOnboardingMailerPreview < ActionMailer::Preview

  def account_verification_in_progress_email
    KycOnboardingMailer.account_verification_in_progress_email(KycOnboarding.submitted.first, KycOnboarding.submitted.first.email_variables)
  end

  def account_verification_complete_email
    KycOnboardingMailer.account_verification_complete_email(KycOnboarding.verified.first, KycOnboarding.verified.first.email_variables)
  end

  def account_verification_rejected_email
    KycOnboardingMailer.account_verification_rejected_email(KycOnboarding.submitted.first, KycOnboarding.submitted.first.email_variables)
  end

  def trigger_account_verification_requires_info_email
    KycOnboardingMailer.account_verification_requires_info_email(KycOnboarding.submitted.first, KycOnboarding.submitted.first.email_variables)
  end
end
