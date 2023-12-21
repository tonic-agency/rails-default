class AddInvoiceNumberToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :invoice_number, :string
  end
end
