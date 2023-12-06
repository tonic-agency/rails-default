class Otp < ApplicationRecord
  belongs_to :owner, polymorphic: true

  OTP_TYPES = %w[mobile_validation email_validation].freeze

  validates :otp_type, presence: true, inclusion: { in: OTP_TYPES }
  after_create :generate_otp
  
  def generate_otp
    return if self.validated_at.present?
    
    self.generate_otp!
  end 
  
  def generate_otp!
    random_passcode = rand(100000..999999)
    self.update(value: random_passcode)

    # self.update(value: random_passcode, validated_at: nil)
  end

  def invalid_otp?(otp)
    return true if otp.blank?
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

  def send_email 
    OtpMailer.default_email(owner, variables: self.owner.email_variables).deliver
  end

  def resend_email
    self.generate_otp!
    self.send_email
  end

  def send_sms(phone = nil, message = nil)
    message = "Enter the one-time-password (OTP) below to verify your mobile number.\n\n #{self.value} \n\nFor your account safety please do not share this with anyone." if message.nil?
    return if phone.nil?
    return if self.value.nil?
    Sms::Base.new.send_message(phone, message)
  end

  def resend_sms
    self.generate_otp!
    self.send_sms(self.owner.phone, nil)
  end
end