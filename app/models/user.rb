class User < ApplicationRecord
  include ApplicationHelper
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  validates_presence_of :first_name, :last_name
  has_one :kyc_onboarding, dependent: :destroy
  has_one :settlement_account, dependent: :destroy
  has_one :referral_code, dependent: :destroy
  has_many :referrals, foreign_key: "from_id", dependent: :destroy
  has_many :referred_users, through: :referrals, source: :referred_user
  has_one :referral, foreign_key: "to_id", dependent: :destroy
  has_many :time_deposit_accounts, dependent: :destroy

  def name 
    "#{self.first_name} #{self.last_name}"
  end
  
  def time_deposit_balance
    return 0 if self.time_deposit_accounts.nil?
    return self.time_deposit_accounts.sum(:amount)
  end

  def total_interest_rate 
    return 0 if self.time_deposit_accounts.nil?
    
    return (TimeDepositAccount::BASE_INTEREST_RATE + self.bonus_rate) * 100
  end

  def base_interest_rate
    return TimeDepositAccount::BASE_INTEREST_RATE * 100
  end

  def bonus_rate 
    return 0 if self.time_deposit_accounts.nil?
    num_referrals = self.referrals.count
    bonus_rate = num_referrals * TimeDepositAccount::BONUS_INTEREST_RATE
    return bonus_rate
  end

  def authorized_to_create_transactions?
    return true if self&.kyc_onboarding&.kyc_onboarding_check&.result == 'verified' && self.settlement_account.present? && self.referral_code.present?
    return false
  end
  
  def referred_by_code
    return if self.referral.nil?
    return self.referral.referrer.referral_code.code
  end
end