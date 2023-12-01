class AddFromAndToAccountTypesToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :from_account_type, :string
    add_column :transactions, :to_account_type, :string
  end
end
