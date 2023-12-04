class Otp < ApplicationRecord
  belongs_to :owner, polymorphic: true

  OTP_TYPES = %w[mobile_validation email_validation].freeze

  validates :otp_type, presence: true, inclusion: { in: OTP_TYPES }
  validates :secret_key, presence: true

  before_validation :generate_secret_key, on: :create
  after_create :generate_otp

  def generate_secret_key
    self.secret_key = ROTP::Base32.random_base32
  end
  
  def generate_otp
    return if self.validated_at.present?
    
    self.generate_otp!
  end 
  
  def generate_otp!
    random_passcode = rand(100000..999999)
    self.update(value: random_passcode)
  end

  def invalid_otp?(otp)
    return true if otp.blank?
    return true if self.validated_at.present?
    return self.value != otp
  end

  def validate_otp(otp)
    if invalid_otp?(otp)
      increment!(:invalid_attempts)
      return false
    else
      update(validated_at: Time.now)
      return true
    end
  end
end
