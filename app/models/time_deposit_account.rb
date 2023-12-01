class TimeDepositAccount < ApplicationRecord
  DEDUCTED_BASE_INTEREST_RATE = 0.055
  BASE_INTEREST_RATE = 0.06
  BONUS_INTEREST_RATE = 0.005
  BASE_TERM = 6
  
  belongs_to :user
  has_one :related_transaction, dependent: :destroy, class_name: 'Transaction', foreign_key: 'to_account_id'

  delegate :name, to: :user

  validates_presence_of :amount, :start_date, :maturity_date, :base_interest_rate, :expected_base_interest, :state
  validates :amount, numericality: { greater_than: 0.0 }
  validate :maturity_date_cannot_be_in_the_past
  validate :amount_does_not_exceed_balance, on: :create
  validate :no_duplicate_records_within_timeframe
  
  scope :open, -> { where(state: 'open') }
  scope :matured, -> { where(state: 'matured') }
  scope :cancelled, -> { where(state: 'cancelled') }

  enum :state, {
    :open => 'Open',
    :matured => 'Matured',
    :cancelled => 'Cancelled'
  }

  before_validation :before_create_callbacks, on: :create
  before_save :set_expected_base_interest
  before_create :build_default_transaction

  def before_create_callbacks
    self.start_date = DateTime.now
    self.maturity_date = self.start_date + BASE_TERM.months
    self.base_interest_rate = self.amount >= 500000 ? BASE_INTEREST_RATE : DEDUCTED_BASE_INTEREST_RATE
    self.state = 'open'
    set_expected_base_interest
  end

  def self.base_interest 
    (BASE_INTEREST_RATE * 100).round(2)
  end
  
  def self.bonus_interest 
    (BONUS_INTEREST_RATE * 100).round(2)
  end

  def set_expected_base_interest
    return unless self.amount.present? && self.base_interest_rate.present?
    
    interest_rate = self.amount >= 500000 ? BASE_INTEREST_RATE : DEDUCTED_BASE_INTEREST_RATE

    self.expected_base_interest = self.amount * interest_rate * (BASE_TERM.to_f / 12.0)
  end

  def build_default_transaction
    self.build_related_transaction(
      date:              self.start_date,
      from_account_type: Transaction::ACCOUNT_TYPES[:settlement][:identifier],
      from_account_id:   self.user.settlement_account.id,
      to_account_type:   Transaction::ACCOUNT_TYPES[:time_deposit][:identifier],
      to_account_id:     self.id,
      state:             Transaction::STATES[:cleared][:identifier],
      transaction_type:  Transaction::TRANSACTION_TYPES[:create_time_deposit][:identifier],
      amount:            self.amount 
    )
  end

  def amount_does_not_exceed_balance
    return if self.user.settlement_account.nil? || self.amount.nil?
    
    unless self.amount <= self.user.settlement_account.current_available_balance
      errors.add(:amount, "cannot exceed balance")
    end
  end

  def maturity_date_cannot_be_in_the_past
    if maturity_date.present? && maturity_date < Date.today
      errors.add(:maturity_date, "can't be in the past")
    end 
  end

  def maturity_date_as_string
    maturity_date = self.maturity_date || DateTime.now + BASE_TERM.months
    maturity_date.strftime("%d %b %Y")
  end

  def maturity_as_percentage
    today = Time.parse(DateTime.now.to_s)
    start_date = Time.parse(self.start_date.to_s)
    maturity_date = Time.parse(self.maturity_date.to_s)
    
    days_in_period = (start_date - maturity_date).seconds.in_hours.to_i.abs
    days_passed = (start_date - today).seconds.in_hours.to_i.abs

    ans = (days_passed.to_f / days_in_period.to_f) * 100
    return ans
  end

  def interest_earned_to_date
    maturity = self.maturity_as_percentage
    expected_interest = self.expected_base_interest

    interest_earned = (maturity.to_d / 100) * expected_interest
    return interest_earned
  end

  private 
  def no_duplicate_records_within_timeframe
    time_frame = 1.minute.ago

    # Check for existing records within the specified timeframe
    existing_records = TimeDepositAccount
      .where(user_id: self.user_id)
      .where(amount: self.amount)
      .where('created_at >= ?', time_frame)
      .where.not(id: self.id) # Exclude the current record when updating

    # Add an error if duplicate records are found
    errors.add(:amount, 'cannot create a duplicate Time Deposit within 1 minute') if existing_records.any?
  end
end