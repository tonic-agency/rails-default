class KycOnboardingCheck < ApplicationRecord
  belongs_to :kyc_onboarding
  belongs_to :admin_user, optional: true

  validate :checks_passed_if_verified

  # Here we'll add a callback to generate a settlement account for the user if the KYC check is verified.
  # We'll also trigger an email to the user to let them know their KYC check has been verified.
  after_save :generate_settlement_account
  after_save :run_result_change_callbacks, if: proc { |kyc| kyc.saved_change_to_result? }

  STATES = {
    :verified => {
      :id => "verified",
    },
    :rejected => {
      :id => "rejected",
    },
    :awaiting_additional_info => {
      :id => "awaiting_additional_info",
    }
  }

  def run_result_change_callbacks
    case self.result.to_sym
    when :verified
      self.trigger_account_verification_complete_email
    when :rejected
      self.trigger_account_verification_rejected_email
    when :awaiting_additional_info
      self.trigger_account_verification_requires_info_email
    end
  end

  def trigger_account_verification_complete_email
    KycOnboardingMailer.account_verification_complete_email(self.kyc_onboarding, self.kyc_onboarding.email_variables).deliver
  end

  def trigger_account_verification_rejected_email
    KycOnboardingMailer.account_verification_rejected_email(self.kyc_onboarding, self.kyc_onboarding.email_variables).deliver
  end

  def trigger_account_verification_requires_info_email
    KycOnboardingMailer.account_verification_requires_info_email(self.kyc_onboarding, self.kyc_onboarding.email_variables).deliver
  end

  def checks_passed_if_verified
    if self.result == "verified"
      errors.add(:information_correct, "must be true") unless self.information_correct
      errors.add(:id_correct, "must be true") unless self.id_correct
      errors.add(:signature_validated, "must be true") unless self.signature_validated
    end
  end

  def generate_settlement_account
    if self.result == "verified"
      return if self.kyc_onboarding.user.settlement_account.present?
      settlement_account = SettlementAccount.new
      settlement_account.institution = Institution.default
      settlement_account.user = self.kyc_onboarding.user
      settlement_account.save
    end
  end

end