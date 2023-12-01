class CreateSecurityQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :security_questions do |t|
      t.references :kyc_onboarding, null: false, foreign_key: true
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
