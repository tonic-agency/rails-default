class RemoveInvoiceNumberFromTransactions < ActiveRecord::Migration[7.0]
  def change
    remove_column :transactions, :invoice_number, :string
  end
end
