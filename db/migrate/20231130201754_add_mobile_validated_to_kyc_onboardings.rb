class AddMobileValidatedToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :mobile_validated, :boolean, default: false
  end
end
