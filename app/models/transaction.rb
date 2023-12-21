class Transaction < ApplicationRecord
  # only digits and optional spaces or dashes
  BANK_ACCOUNT_REGEX = /\A[0-9\s-]*\z/
  
  has_one_attached :deposit_slip
  has_one_attached :check
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

  DEPOSIT_TYPES_FOR_ADD_FUNDS = {
    :online_transfer => {
      :name => 'Bank Deposit/Online Transfer',
      :identifier => 'online_transfer'
    },
    :check_deposit => {
      :name => 'Check Deposit',
      :identifier => 'check_deposit'
    },
  }

  validates :from_account_type, inclusion: { in: Transaction::ACCOUNT_TYPES.map{|symbol,attributes| attributes[:identifier] }, message: "Must be either 'settlement' or 'time_deposit'", allow_blank: true}
  validates :to_account_type, inclusion: { in: ACCOUNT_TYPES.map{|symbol,attributes| attributes[:identifier] }, message: "Must be either 'settlement' or 'time_deposit'", allow_blank: true}
  validates :state, inclusion: { in: STATES.map{|symbol,attributes| attributes[:identifier] }, message: "Not a valid state"}
  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES.map{|symbol,attributes| attributes[:identifier] }, message: "Not a valid transaction type"}
  validates_presence_of :amount
  validates :amount, numericality: { greater_than: 0.0 }
  validate :no_duplicate_records_within_timeframe
  
  # Add funds validations
  # validates_presence_of :from_account_id, :from_account_type, :deposit_slip, on: [:edit, :update]
  validates_presence_of :deposit_type, if: -> { self.of_type_add_funds? }
  validates :deposit_type, inclusion: { in: DEPOSIT_TYPES_FOR_ADD_FUNDS.map{|symbol,attributes| attributes[:identifier] }, message: "Not a valid deposit type"}, if: -> { self.of_type_add_funds? }
  # Online Transfers
  validate :acceptable_deposit_slip, if: -> { self.of_type_add_funds? && self.of_deposit_type_online_transfer? }
  validates_presence_of :bank_account_number, if: -> { self.of_type_add_funds? && self.of_deposit_type_online_transfer? }, on: :create
  validates_format_of :bank_account_number, with: BANK_ACCOUNT_REGEX, message: "must only contain numbers, spaces and hyphens.", if: -> { self.of_type_add_funds? && self.of_deposit_type_online_transfer? }
  # Check Deposits
  validate :acceptable_check, if: -> { self.of_type_add_funds? && self.of_deposit_type_check_deposit? }

  scope :pending, -> { where(state: 'pending') }
  scope :rejected, -> { where(state: 'rejected') }
  scope :cleared, -> { where(state: 'cleared') }
  scope :add_funds, -> { where(transaction_type: 'add_funds') }
  scope :time_deposits, -> { where(transaction_type: 'create_time_deposit') }

  before_save :set_balance, if: -> { self.state_cleared? }
  before_save :sanitize_bank_account_number, if: -> { self.of_type_add_funds? && self.of_deposit_type_online_transfer? }
  after_create :send_add_funds_verification_in_progress_email, if: -> { self.of_type_add_funds? }
  after_save :send_add_funds_cleared_email, if: -> { self.of_type_add_funds? && self.state_changed? && self.state_cleared? }
  after_save :send_add_funds_rejected_email, if: -> { self.of_type_add_funds? && self.state_changed? && self.state_rejected? }

  def label 
    "#{self.id} - #{self.transaction_type.titleize} - #{self.amount}"
  end

  def of_type_add_funds?
    self.transaction_type == Transaction::TRANSACTION_TYPES[:add_funds][:identifier]
  end

  def of_type_time_deposit?
    self.transaction_type == Transaction::TRANSACTION_TYPES[:create_time_deposit][:identifier]
  end

  def of_deposit_type_online_transfer?
    self.deposit_type == Transaction::DEPOSIT_TYPES_FOR_ADD_FUNDS[:online_transfer][:identifier]
  end

  def of_deposit_type_check_deposit?
    self.deposit_type == Transaction::DEPOSIT_TYPES_FOR_ADD_FUNDS[:check_deposit][:identifier]
  end

  def state_cleared?
    self.state == Transaction::STATES[:cleared][:identifier]
  end

  def state_pending?
    self.state == Transaction::STATES[:pending][:identifier]
  end

  def state_rejected?
    self.state == Transaction::STATES[:rejected][:identifier]
  end

  def set_balance
    return unless self.valid?
    
    if self.of_type_add_funds?
      self.balance = self.to_account.current_available_balance + self.amount
    elsif self.of_type_time_deposit?
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
    return unless self.of_type_time_deposit?
    errors.add(:amount, "must be less than or equal to available balance") unless self.amount <= self.from_account.current_available_balance
  end

  def set_properties_for_type_add_funds(**args)
    self.state            = Transaction::STATES[:pending][:identifier]
    self.transaction_type = Transaction::TRANSACTION_TYPES[:add_funds][:identifier]
    self.to_account_type  = Transaction::ACCOUNT_TYPES[:settlement][:identifier]
    self.date             = args[:date]
  end

  def eligible_for_approval?
    self.transaction_approval.nil? && self.state_pending?
  end

  def requires_approval?
    self.of_type_add_funds?
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

  def send_add_funds_verification_in_progress_email
    # AddFundsMailer.transaction_created(self).deliver_later
  end

  def send_add_funds_cleared_email
    # AddFundsMailer.transaction_cleared(self).deliver_later
  end

  def send_add_funds_rejected_email
    # AddFundsMailer.transaction_rejected(self).deliver_later
  end

  private

  def sanitize_bank_account_number
    self.bank_account_number = self.bank_account_number.gsub(/[ -]/, '')
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

  # TODO: Repurpose this for check deposits
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

  def acceptable_check
    unless check.attached?
      errors.add(:check, "is missing")
      return
    end
  
    unless check.blob.byte_size <= 1.megabyte
      errors.add(:check, "is too big")
      return
    end
  
    acceptable_types = ["image/jpeg", "image/png", "application/pdf"] 
    
    unless acceptable_types.include?(check.content_type)
      errors.add(:check, "must be a JPEG, PDF or PNG")
    end
  end

end