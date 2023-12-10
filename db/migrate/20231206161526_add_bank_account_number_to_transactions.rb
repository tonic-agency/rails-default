class AddBankAccountNumberToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :bank_account_number, :string
  end
end
