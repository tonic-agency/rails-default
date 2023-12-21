class TimeDepositMailer < ApplicationMailer
  def account_creation_email(time_deposit_account)
    @time_deposit_account = time_deposit_account
    @recipient = time_deposit_account.user

    mail(to: @recipient.email, subject: "Your Farmbank Time Deposit is Officially Active!")
  end

  def referral_scheme_info_email(time_deposit_account)
    @time_deposit_account = time_deposit_account
    @recipient = time_deposit_account.user

    mail(to: @recipient.email, subject: "Boost Your Earnings with Farmbank's Referral Scheme!")
  end

  def referral_interest_bonus_email(referral)
    @referral = referral
    @recipient = referral.referrer

    mail(to: @recipient.email, subject: "You've Earned a Referral Interest Bonus!")
  end
end
