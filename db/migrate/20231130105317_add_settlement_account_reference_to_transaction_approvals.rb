class AddSettlementAccountReferenceToTransactionApprovals < ActiveRecord::Migration[7.0]
  def change
    add_reference :transaction_approvals, :settlement_account, foreign_key: true, index: true
  end
end
