class CreateSettlementAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :settlement_accounts do |t|
      t.integer :institution_id
      t.integer :user_id

      t.timestamps
    end
  end
end
