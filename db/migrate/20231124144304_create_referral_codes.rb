class CreateReferralCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :referral_codes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code, null: false
      
      t.timestamps
    end
  end
end
