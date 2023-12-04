class SettlementAccount < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :institution, optional: true
  has_many :transaction_approvals
  has_many :outgoing_transactions, class_name: "Transaction", :foreign_key => "from_account_id"
  has_many :incoming_transactions, class_name: "Transaction", :foreign_key => "to_account_id"

  delegate :current_available_balance, to: :user
  delegate :name, to: :user, :allow_nil => true

  # validates_uniqueness_of :account_number, :allow_blank => true
  # validates_presence_of :account_name, if: proc {|account| account.user.nil? }

  scope :internal, -> { where(institution_id: 1) }
  scope :external, -> { where.not(institution_id: 1) }

  def name
    return self.user.name if self.user.present?
    return self.account_name if self.account_name.present?
  end
  
  def current_available_balance
    self.total_cleared_incomings - self.total_cleared_outgoings
  end

  def ordered_outgoing_transactions
    self.outgoing_transactions.with_attached_deposit_slip.where(from_account_type: 'settlement').order(created_at: :desc)
  end

  def ordered_incoming_transactions
    self.incoming_transactions.with_attached_deposit_slip.where(to_account_type: 'settlement').order(created_at: :desc)
  end

  def ordered_total_transactions
    return [] if self.ordered_outgoing_transactions.nil? && self.ordered_incoming_transactions.nil?
    return (self.ordered_outgoing_transactions + self.ordered_incoming_transactions).sort_by(&:created_at).reverse
  end

  def total_cleared_outgoings
    return 0 if self.ordered_outgoing_transactions.nil?
    return self.ordered_outgoing_transactions.where(state: 'cleared').sum(:amount)
  end

  def total_cleared_incomings
    return 0 if self.ordered_incoming_transactions.nil?
    return self.ordered_incoming_transactions.where(state: 'cleared').sum(:amount)
  end
end