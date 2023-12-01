class AddSignaturePresentAtOnboardingToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :signature_present_at_onboarding, :boolean, default: true
  end
end
