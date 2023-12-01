class AddWasRefferedToKycOnboardings < ActiveRecord::Migration[7.0]
  def change
    add_column :kyc_onboardings, :was_referred, :boolean
  end
end
