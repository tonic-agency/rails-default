class Otp < ApplicationRecord
  belongs_to :owner, polymorphic: true

  OTP_TYPES = %w[mobile_validation email_validation].freeze

  validates :otp_type, presence: true, inclusion: { in: OTP_TYPES }
  
  after_create :generate_otp

  attr_accessor :value_1, :value_2, :value_3, :value_4, :value_5, :value_6

  cattr_accessor :email, :mobile
  
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

  def send_email(variables = {})
    return if self.email.nil?
    variables = self.owner.email_variables
    return if variables.nil?
    
    OtpMailer.default_email(self.email, variables).deliver_later
  end

  def resend_email(variables = {})
    self.generate_otp!
    self.send_email(variables)
  end

  def send_sms(message = nil)
    return if self.mobile.nil?
    return if self.value.nil?

    message = "Enter the one-time-password (OTP) below to verify your mobile number.\n\n #{self.value} \n\nFor your account safety please do not share this with anyone." if message.nil?
    
    Sms::Base.new.send_message(self.mobile, message)
  end

  def resend_sms(message = nil)
    self.generate_otp!
    self.send_sms(message)
  end
end
