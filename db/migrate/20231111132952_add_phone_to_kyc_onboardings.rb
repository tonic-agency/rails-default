class AddPhoneToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :phone, :text
  end
end
