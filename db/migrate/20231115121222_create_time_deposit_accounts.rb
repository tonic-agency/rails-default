class CreateTimeDepositAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :time_deposit_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.datetime :start_date
      t.datetime :maturity_date
      t.decimal :base_interest_rate
      t.decimal :expected_base_interest
      t.boolean :auto_renewal, default: false
      t.string :state
      t.boolean :realised_interest, default: false

      t.timestamps
    end
  end
end
