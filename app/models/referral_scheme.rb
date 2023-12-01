class ReferralScheme < ApplicationRecord
  # belongs to referral 
  validates_presence_of :relative_balance, :referral_interest_rate
  validates_numericality_of :relative_balance, :referral_interest_rate, greater_than_or_equal_to: 0.0

  BASE_INTEREST_RATE = TimeDepositAccount::BONUS_INTEREST_RATE

end