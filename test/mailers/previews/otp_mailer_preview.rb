# Preview all emails at http://localhost:3000/rails/mailers/otp_mailer
class OtpMailerPreview < ActionMailer::Preview

  def default_email
    OtpMailer.default_email(KycOnboarding.find(107),  KycOnboarding.find(107).email_variables)
  end
end
