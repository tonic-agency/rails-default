class AddAccountNumberToSettlementAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :settlement_accounts, :account_number, :string
  end
end
