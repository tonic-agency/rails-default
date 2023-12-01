class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.datetime :date
      t.integer :from_account_id
      t.integer :to_account_id
      t.string :state
      t.string :transaction_type

      t.timestamps
    end
  end
end
