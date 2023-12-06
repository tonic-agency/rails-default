class TransactionApproval < ApplicationRecord
  belongs_to :admin_user
  belongs_to :settlement_account, optional: true
  belongs_to :corresponding_transaction, class_name: "Transaction", foreign_key: "transaction_id"

  RESULTS = {
    :rejected => {
      :id => "rejected",
    },
    :approved => {
      :id => "approved",
    }
  }

  # attr_accessor :from_account_number
  # attr_accessor :from_account_institution_id

  validates :result, presence: true
  validates :result, inclusion: { in: TransactionApproval::RESULTS.map{|symbol,attributes| attributes[:id] }, message: "Not a valid result"}
  # validates :from_account_number, :from_account_institution_id, presence: true

  after_save :update_transaction_state

  def update_transaction_state
    if self.result == TransactionApproval::RESULTS[:approved][:id]
      self.corresponding_transaction.update!(state: Transaction::STATES[:cleared][:identifier])
    elsif self.result == TransactionApproval::RESULTS[:rejected][:id]
      self.corresponding_transaction.update!(state: Transaction::STATES[:rejected][:identifier])
    end
  end


end
