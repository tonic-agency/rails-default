class AddAccountNameToSettlementAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :settlement_accounts, :account_name, :string
  end
end
