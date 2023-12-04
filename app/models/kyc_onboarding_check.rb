class KycOnboardingCheck < ApplicationRecord
  belongs_to :kyc_onboarding
  belongs_to :admin_user, optional: true

  validate :checks_passed_if_verified

  # Here we'll add a callback to generate a settlement account for the user if the KYC check is verified.
  # We'll also trigger an email to the user to let them know their KYC check has been verified.
  after_save :generate_settlement_account

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

  def checks_passed_if_verified
    if self.result == "verified"
      errors.add(:information_correct, "must be true") unless self.information_correct
      errors.add(:id_correct, "must be true") unless self.id_correct
      errors.add(:signature_validated, "must be true") unless self.signature_validated
    end
  end

  # trigger a verification email to the user if the kyc check result changes to verified
  def trigger_verification_email
    # if result has changed to verified after save 
    if self.result_changed? && self.result == "verified" 
      # send verification email
      # KycOnboardingCheckMailer.with(kyc_onboarding_check: self).verification_email.deliver_now
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