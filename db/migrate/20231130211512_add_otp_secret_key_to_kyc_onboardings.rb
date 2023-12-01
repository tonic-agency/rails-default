class AddOtpSecretKeyToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :otp_secret_key, :string
  end
end
