class CreateKycOnboardingChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :kyc_onboarding_checks do |t|
      t.integer :admin_user_id
      t.integer :kyc_onboarding_id
      t.boolean :information_correct
      t.boolean :id_correct
      t.boolean :signature_validated
      t.string :result

      t.timestamps
    end
  end
end
