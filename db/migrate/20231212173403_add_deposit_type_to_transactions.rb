class AddDepositTypeToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :deposit_type, :string
  end
end
