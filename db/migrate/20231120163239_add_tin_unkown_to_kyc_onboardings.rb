class AddTinUnkownToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :tin_known, :boolean, default: true
  end
end
