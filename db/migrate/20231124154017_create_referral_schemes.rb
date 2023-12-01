class CreateReferralSchemes < ActiveRecord::Migration[7.0]
  def change
    create_table :referral_schemes do |t|
      t.decimal :relative_balance, null: false, default: 0.0
      t.decimal :referral_interest_rate, null: false, default: 0.0

      t.timestamps
    end
  end
end
