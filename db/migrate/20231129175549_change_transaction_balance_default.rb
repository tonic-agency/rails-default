class ChangeTransactionBalanceDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :transactions, :balance, from: 0.0, to: nil
  end
end
