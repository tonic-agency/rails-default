class AddIdentifierToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :identifier, :string
  end
end
