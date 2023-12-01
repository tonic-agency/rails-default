class CreateTransactionApprovals < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_approvals do |t|
      t.references :transaction, null: false, foreign_key: true
      t.references :admin_user, null: false, foreign_key: true
      t.string :result, null: false

      t.timestamps
    end
  end
end
