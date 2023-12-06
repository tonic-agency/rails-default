class Transaction < ApplicationRecord
  has_one_attached :deposit_slip
  has_one :transaction_approval, dependent: :destroy, inverse_of: :corresponding_transaction
  accepts_nested_attributes_for :transaction_approval
  belongs_to :from_settlement_account, optional: true, class_name: "SettlementAccount", :foreign_key => "from_account_id"
  belongs_to :to_settlement_account, optional: true, class_name: "SettlementAccount", :foreign_key => "to_account_id"
  belongs_to :from_time_deposit_account, optional: true, class_name: "TimeDepositAccount", :foreign_key => "from_account_id"
  belongs_to :to_time_deposit_account, optional: true, class_name: "TimeDepositAccount", :foreign_key => "to_account_id"

  ACCOUNT_TYPES = {
    :settlement => {
      :name => 'Settlement Account',
      :identifier => 'settlement'
    },
    :time_deposit => {
      :name => 'Time Deposit Account',
      :identifier => 'time_deposit'
    }
  }

  STATES = {
    :pending => {
      :name => 'Pending',
      :identifier => 'pending'
    },
    :cleared => {
      :name => 'Cleared',
      :identifier => 'cleared'
    },
    :rejected => {
      :name => 'Rejected',
      :identifier => 'rejected'
    },
    :withdrawal_requested => {
      :name => 'Withdrawal Requested',
      :identifier => 'withdrawal_requested'
    },
    :cancellation_pending => {
      :name => 'Cancellation Pending',
      :identifier => 'cancellation_pending'
    }
  }

  TRANSACTION_TYPES = { 
    :add_funds => {
      :name => 'Add Funds',
      :identifier => 'add_funds'
    },
    :create_time_deposit => {
      :name => 'Create Time Deposit',
      :identifier => 'create_time_deposit'
    },
    :withdrawal_request => {
      :name => 'Withdrawal Request',
      :identifier => 'withdrawal_request'
    },
    :time_deposit_maturity => {
      :name => 'Time Deposit Maturity',
      :identifier => 'time_deposit_maturity'
    },
    :interest_payment => {
      :name => 'Interest Payment',
      :identifier => 'interest_payment'
    },
    :time_deposit_cancellation => {
      :name => 'Time Deposit Cancellation',
      :identifier => 'time_deposit_cancellation'
    }
  }

  validates :from_account_type, inclusion: { in: Transaction::ACCOUNT_TYPES.map{|symbol,attributes| attributes[:identifier] }, message: "Must be either 'settlement' or 'time_deposit'", allow_blank: true}
  validates :to_account_type, inclusion: { in: ACCOUNT_TYPES.map{|symbol,attributes| attributes[:identifier] }, message: "Must be either 'settlement' or 'time_deposit'", allow_blank: true}
  validates :state, inclusion: { in: STATES.map{|symbol,attributes| attributes[:identifier] }, message: "Not a valid state"}
  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES.map{|symbol,attributes| attributes[:identifier] }, message: "Not a valid transaction type"}
  validates_presence_of :amount
  validates :amount, numericality: { greater_than: 0.0 }
  validate :no_duplicate_records_within_timeframe
  validate :validate_invoice_number 
  # validates_presence_of :from_account_id, :from_account_type, :deposit_slip, on: [:edit, :update]
  # validate :acceptable_deposit_slip, if: -> { self.transaction_type == Transaction::TRANSACTION_TYPES[:add_funds][:identifier] }

  scope :pending, -> { where(state: 'pending') }
  scope :rejected, -> { where(state: 'rejected') }
  scope :add_funds, -> { where(transaction_type: 'add_funds') }
  scope :time_deposits, -> { where(transaction_type: 'create_time_deposit') }

  before_save :set_balance, if: -> { self.state == Transaction::STATES[:cleared][:identifier] }

  attr_accessor :invoice_number_provided

  def label 
    "#{self.id} - #{self.transaction_type.titleize} - #{self.amount}"
  end

  # TODO: Refactor
  def invoice_number_provided
    @invoice_number_provided || false
  end

  def set_balance
    return unless self.valid?
    
    case self.transaction_type
    when 'add_funds'
      self.balance = self.to_account.current_available_balance + self.amount
    when 'create_time_deposit'
      self.balance = self.from_account.current_available_balance - self.amount
    end

  end
  
  def from_account
    case from_account_type
    when 'settlement'
      self.from_settlement_account
    when 'time_deposit'
      self.from_time_deposit_account
    end
  end

  def to_account
    case to_account_type
    when 'settlement'
      self.to_settlement_account
    when 'time_deposit'
      self.to_time_deposit_account
    end
  end

  def acceptable_deposit_slip
    unless deposit_slip.attached?
      errors.add(:deposit_slip, "is missing")
      return
    end
  
    unless deposit_slip.blob.byte_size <= 1.megabyte
      errors.add(:deposit_slip, "is too big")
      return
    end
  
    acceptable_types = ["image/jpeg", "image/png", "application/pdf"] 
    
    unless acceptable_types.include?(deposit_slip.content_type)
      errors.add(:deposit_slip, "must be a JPEG, PDF or PNG")
    end
  end

  def no_potential_duplicity
    potential_duplicate = Transaction.find_by(
      amount: self&.amount,
      from_account_type: self&.from_account_type,
      from_account_id: self&.from_account_id,
      to_account_type: self&.to_account_type,
      to_account_id: self&.to_account_id,
      transaction_type: self&.transaction_type,
    )

    return if  potential_duplicate.nil?
    
    if potential_duplicate.present?
      errors.add(:amount, "identical to transaction made #{potential_duplicate.created_at.strftime("%b %d, %Y at %I:%M%p")}")
    end
  end

  def has_adequate_funds_for_time_deposit?
    return unless self.transaction_type == Transaction::TRANSACTION_TYPES[:create_time_deposit][:identifier]
    errors.add(:amount, "must be less than or equal to available balance") unless self.amount <= self.from_account.current_available_balance
  end

  def set_properties_for_type_add_funds(**args)
    self.state            = Transaction::STATES[:pending][:identifier]
    self.transaction_type = Transaction::TRANSACTION_TYPES[:add_funds][:identifier]
    self.to_account_type  = Transaction::ACCOUNT_TYPES[:settlement][:identifier]
    self.date             = args[:date]
  end

  def eligible_for_approval?
    self.transaction_approval.nil? && self.state == Transaction::STATES[:pending][:identifier]
  end

  def requires_approval?
    self.transaction_type == Transaction::TRANSACTION_TYPES[:add_funds][:identifier]
  end

  def state_style_helper
    case self.state
    when 'pending'
      'bg-gray-200 text-gray-700'
    when 'cleared'
      'bg-green-100 text-green-700'
    when 'rejected'
      'bg-red-200 text-red-700'
    when 'withdrawal_requested'
      'bg-blue-200 text-blue-700'
    when 'cancellation_pending'
      'bg-orange-200 text-orange-700'
    end
  end
  
  private

  def validate_invoice_number
    return unless self.invoice_number_provided == true
    return unless self.transaction_type == Transaction::TRANSACTION_TYPES[:add_funds][:identifier]
    
    if self.invoice_number.blank?
      errors.add(:invoice_number, "can't be blank")
    elsif self.invoice_number.length < 6
      errors.add(:invoice_number, "must be at least 6 characters")
    end
  end

  def no_duplicate_records_within_timeframe
    time_frame = 1.minute.ago

    # Check for existing records within the specified timeframe
    existing_records = Transaction
      .where(from_account_type: self.from_account_type)
      .where(from_account_id: self.from_account_id)
      .where(to_account_type: self.to_account_type)
      .where(to_account_id: self.to_account_id)
      .where(amount: self.amount)
      .where('created_at >= ?', time_frame)
      .where.not(id: self.id) # Exclude the current record when updating

    # Add an error if duplicate records are found
    errors.add(:amount, 'cannot create a duplicate Transaction within 1 minute') if existing_records.any?
  end

end