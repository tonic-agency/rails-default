class CreateReferrals < ActiveRecord::Migration[7.0]
  def change
    create_table :referrals do |t|
      t.references :from, null: false, foreign_key: { to_table: :users }
      t.references :to, null: false, foreign_key: { to_table: :users }
      t.references :referral_scheme, null: false, foreign_key: true

      t.timestamps
    end
  end
end
