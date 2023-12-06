class RemoveOtpFromKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    remove_column :kyc_onboardings, :otp_secret_key, :string
    remove_column :kyc_onboardings, :last_otp_at, :datetime
  end
end
