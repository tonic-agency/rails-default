class AddLastOtpAtToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :last_otp_at, :integer
  end
end
