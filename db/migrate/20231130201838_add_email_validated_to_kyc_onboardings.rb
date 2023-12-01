class AddEmailValidatedToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :email_validated, :boolean, default: false
  end
end
