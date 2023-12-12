# Preview all emails at http://localhost:3000/rails/mailers/time_deposit_mailer
class TimeDepositMailerPreview < ActionMailer::Preview
  def account_creation_email
    TimeDepositMailer.account_creation_email(TimeDepositAccount.last)
  end

  def referral_scheme_info_email
    TimeDepositMailer.referral_scheme_info_email(TimeDepositAccount.last)
  end

  def referral_interest_bonus_email
    TimeDepositMailer.referral_interest_bonus_email(Referral.last)
  end
end
