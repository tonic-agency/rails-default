class AddBalanceToTransactionsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :balance, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
