class AddUserIdToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :user_id, :integer
  end
end
