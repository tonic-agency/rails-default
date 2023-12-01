class AddEmailToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :email, :text
  end
end
