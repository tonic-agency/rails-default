class KycOnboarding < ApplicationRecord
  PHONE_NUMBER_REGEX = /\(?(09[0-9]{2})\)?([ ])([0-9]{3})\2([0-9]{4})/
  # EMAIL_REGEX = URI::MailTo::EMAIL_REGEXP
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  belongs_to :user, optional: true
  has_one_attached :id_file_front
  has_one_attached :id_file_back
  has_one_attached :signature_id, dependent: :detach
  has_many :security_questions, dependent: :destroy
  has_one :kyc_onboarding_check
  has_one :mobile_otp, as: :owner, class_name: "Otp", dependent: :destroy
  has_one :email_otp, as: :owner, class_name: "Otp", dependent: :destroy
  before_validation :generate_identifier
  before_validation :generate_user
  before_validation :set_defaults
  # before_validation :set_monthly_income, if: proc { |kyc| kyc.validation_set == "financial_info" }
  after_create :generate_security_questions
  after_save :run_after_submit_callbacks

  attr_accessor :current_step

  validates_presence_of :state
  validates_presence_of :identifier
  
  validates_presence_of :first_name, :last_name

  validates_presence_of :phone, if: proc { |kyc| kyc.validation_set == "phone"  }
  validate :valid_phone_length, if: proc { |kyc| kyc.validation_set == "phone" }
  validates_format_of :phone, :with =>  PHONE_NUMBER_REGEX, :message => "must be a valid mobile number in the format (09XX) XXX XXXX", if: proc { |kyc| kyc.validation_set == "phone"  }
  
  validates_presence_of :email, if: proc { |kyc| kyc.validation_set == "email" }
  validates_format_of :email, :with => EMAIL_REGEX, if: proc { |kyc| kyc.validation_set == "email" }
  validates_uniqueness_of :email, if: proc { |kyc| kyc.validation_set == "email" }

  attr_accessor :validation_set
  attr_accessor :password
  attr_accessor :password_confirmation
  attr_accessor :referral_code
  attr_accessor :mobile_otp_code
  attr_accessor :email_otp_code

  accepts_nested_attributes_for :security_questions
  
  validates_presence_of :date_of_birth, :place_of_birth, :nationality, :marital_status,  if: proc { |kyc| kyc.validation_set == "personal_info" }
  validate :validate_age, if: proc { |kyc| kyc.validation_set == "personal_info" }
  
  validates_presence_of :address_house_number, :address_street_name, :address_province, :address_city, :address_barangay, :address_country, if: proc { |kyc| kyc.validation_set == "residential_info"  }
  
  validates_presence_of :source_of_funds, if: proc { |kyc| kyc.validation_set == "financial_info" }
  validates_numericality_of :gross_monthly_income, if: proc { |kyc| kyc.validation_set == "financial_info" }
  
  validates_presence_of :work_occupation, :work_employer_name, :work_employer_address, :work_employer_contact_number, if: proc { |kyc| kyc.validation_set == "work_info" }
  validate :valid_employer_phone_length, if: proc { |kyc| kyc.validation_set == "work_info" }
  validates_format_of :work_employer_contact_number, :with =>  PHONE_NUMBER_REGEX, :message => "must be a valid mobile number in the format (09XX) XXX XXXX", if: proc { |kyc| kyc.validation_set == "work_info"  }
  
  validates_presence_of :tax_identification_number , if: proc { |kyc| kyc.validation_set == "tax_id" && kyc.tin_known}
  validates_numericality_of :tax_identification_number , if: proc { |kyc| kyc.validation_set == "tax_id" && kyc.tin_known}
  # validates_presence_of :ssis_gsis_number, if: proc { |kyc| kyc.validation_set == "tax_id" && kyc.address_country == 'Philippines' }
  
  validates_presence_of :id_file_front, :id_file_back, if: proc { |kyc| kyc.validation_set == "id_upload" }
  validate :acceptable_id_files, if: proc { |kyc| kyc.validation_set == "id_upload" }
  
  validates_presence_of :signature_id, if: proc { |kyc| kyc.validation_set == "signature_specimen" && kyc.signature_present_at_onboarding }
  validate :acceptable_signature_id, if: proc { |kyc| kyc.validation_set == "signature_specimen" && kyc.signature_present_at_onboarding }
  
  validate :validate_security_questions, if: proc { |kyc| kyc.validation_set == "security_questions" }

  validate :was_referred_valid, if: proc {|kyc| kyc.validation_set == "referral_program_start"}
  validate :referral_valid, if: proc {|kyc| kyc.validation_set == "referral_code"}

  before_validation :mobile_otp_valid, if: proc {|kyc| kyc.validation_set == "mobile_otp"}
  before_validation :email_otp_valid, if: proc {|kyc| kyc.validation_set == "email_otp"}
  
  scope :incomplete, -> { where(state: STATES[:incomplete][:id]) }

  STATES = {
    :incomplete => {
      :id => "incomplete",
    },
    :submitted => {
      :id => "submitted",
    }
  }

  def generate_and_send_otp 
    # generate mobile otp
    # send to user 
  end
  
  
  def generate_identifier
    Utilities.generate_identifier(self)
  end

  def generate_user
    return unless self.validation_set == "password"

    user = User.new(
      email:                  self.email,
      first_name:             self.first_name,
      last_name:              self.last_name,
      password:               self.password,
      password_confirmation:  self.password_confirmation
    )
    if user.save
      self.user_id = user.id
    else 
      self.errors.add(:base, user.errors.full_messages.join(", "))
    end
  end

  def was_referred_valid
    return unless self.validation_set == "referral_program_start"

    if self.was_referred.nil?
      self.errors.add(:base, "Please select an option.")
    elsif !self.was_referred && self.user.referral.present?
      self.user.referral.destroy
    end
  end

  def referral_valid
    return unless self.validation_set == "referral_code" && self.was_referred

    if self.referral_code.blank?
      self.errors.add(:base, "Referral code is required.")
      return
    end

    if self.user.referral.present?
      self.errors.add(:base, "You have already been referred.")
      return
    end

    referral_code = ReferralCode.find_by(code: self.referral_code)
    
    if referral_code.present?
      self.generate_referral(referral_code)
    else
      self.errors.add(:base, "Referral code is invalid.")
    end
  end

  def generate_referral(referral_code)
    return unless self.validation_set == "referral_code" && self.was_referred? && self.referral_code.present?
    
    self.user.build_referral(from_id: referral_code.user_id, referral_scheme_id: ReferralScheme.first.id)
    self.user.save
  end

  def submit! 
    if self.valid? 
      self.state = STATES[:submitted][:id]
      self.save
    end
  end

  def run_after_submit_callbacks
    if saved_change_to_state? && self.state == STATES[:submitted][:id]
      self.trigger_verification_in_progress_email
      self.generate_referral_code
    end
  end

  def trigger_verification_in_progress_email
    # KycOnboardingMailer.account_verification_in_progress_email(self).deliver_now
  end

  def generate_referral_code
    return if self.user.referral_code.present?
    self.user.build_referral_code
    self.user.save
  end

  def eligible_for_verification?
    self.state == STATES[:submitted][:id] && self.kyc_onboarding_check.blank?
  end

  def verified?
    self.kyc_onboarding_check&.result == KycOnboardingCheck::STATES[:verified][:id]
  end

  def incomplete?
    self.state == STATES[:incomplete][:id]
  end

  def generate_security_questions
    return if self.security_questions.count == 2

    2.times do |index|
      SecurityQuestion.create!(kyc_onboarding_id: self.id, order: index)
    end
  end

  def current_step
    return "name" if self.first_name.blank? || self.last_name.blank?
    return "phone" if self.phone.blank?
    return "email" if self.email.blank?
    return "password" if self.user_id.blank?
    return "personal_info" if self.date_of_birth.blank? || self.place_of_birth.blank? || self.nationality.blank? || self.marital_status.blank?
    return "residential_info" if self.address_house_number.blank? || self.address_street_name.blank? || self.address_province.blank? || self.address_city.blank? || self.address_barangay.blank? || self.address_country.blank?
    return "financial_info" if self.source_of_funds.blank? || self.gross_monthly_income.blank? 
    return "work_info" if self.source_of_funds == 'Salary' && (self.work_occupation.blank? || self.work_employer_name.blank? || self.work_employer_address.blank? || self.work_employer_contact_number.blank?)
    return "tax_id" if (self.tax_identification_number.blank? && self.tin_known)
    return "id_upload" if self.id_file_front.blank? || self.id_file_back.blank?
    return "signature_specimen" if (self.signature_id.blank? && self.signature_present_at_onboarding)
    return "security_questions" if !self.security_questions_complete?
    return "referral_program_start" if self.was_referred.nil?
    return "referral_program_code" if self.was_referred && self.user.referral.nil?
    return "summary"
    return "complete"
  end

  def step_index(step = nil)
    step ||= self.current_step

    return STEPS.find_index(step)
  end

  STEPS =
    ["name",
    "phone",
    "email",
    
    "password",
    "personal_info",
    "residential_info",
    "financial_info",
    "work_info",
    "tax_id",
    "id_upload",
    "signature_specimen",
    "security_questions",
    "referral_program_start",
    "referral_program_code",
    "summary",
    "complete"]
  

  def previous_step(step = nil)
    step ||= self.current_step
    
    case step
    when "name"
      return nil 
    when "tax_id"
      if self.source_of_funds == 'Salary'
        return "work_info"
      else
        return "financial_info"
      end
    when "password"
      if self.email_validated
        return "email"
      end
    when "email"
      if self.mobile_validated
        return "phone"
      end
    when "summary"
      return "referral_program_code" if self.was_referred
      return "referral_program_start" if !self.was_referred
    else 
      return STEPS[step_index(step) - 1]
    end
  end

  def next_step(step = nil)
    step ||= self.current_step

    case step
    when "financial_info"
      if self.source_of_funds == 'Salary'
        return "work_info"
      else
        return "tax_id"
      end
    when "phone"
      if self.mobile_validated
        return "email"
      end
    when "email"
      if self.email_validated
        return "password"
      end
    when "referral_program_start"
      return "referral_program_code" if self.was_referred
      return "summary" if !self.was_referred
    else
      return STEPS[step_index(step) + 1]
    end
  end

  def set_defaults
    self.state ||= STATES[:incomplete][:id]
  end

  def set_monthly_income
    self.gross_monthly_income = self&.gross_monthly_income&.to_s&.delete(',').to_f
  end

  def name 
    "#{self.first_name} #{self&.middle_name} #{self.last_name}"
  end 

  def full_address
    "#{self.address_house_number} #{self.address_street_name}, #{self.address_barangay}, #{self.address_city}, #{self.address_province}, #{self.address_country}"
  end

  def identification_number
    self.tax_identification_number || self.ssis_gsis_number
  end

  def security_questions_complete?
    self.security_questions.pluck(:question, :answer).flatten.reject { |e| e.to_s.empty? }.length == 4
  end

  private
  def validate_tax_id 
    return if !self.tin_known
    if self.tax_identification_number.blank?
      errors.add(:tax_identification_number, 'is required.')
    end
  end 

  def validate_age
    return unless self.date_of_birth.present?
    
    if self.date_of_birth > 18.years.ago
      errors.add(:date_of_birth, ': you must be over 18 years old')
    end
    if self.date_of_birth.future?
      errors.add(:date_of_birth, 'cannot be in the future')
    end
  end

  def valid_phone_length 
    return if self.phone.blank?

    sanitized_phone = self.phone.gsub(/[^a-zA-Z0-9]/, '')
    
    if sanitized_phone.length != 11
      errors.add(:phone, 'must be exactly 11 characters')
    end
  end

  def valid_employer_phone_length 
    return if self.work_employer_contact_number.blank?

    sanitized_employer_phone = self.work_employer_contact_number.gsub(/[^a-zA-Z0-9]/, '')
    
    if sanitized_employer_phone.length != 11
      errors.add(:work_employer_contact_number, 'must be exactly 11 characters')
    end
  end

  def validate_security_questions
    if self.security_questions.first.question == self.security_questions.second.question
      self.errors.add("question_1".to_sym, "must be unique.")
      self.errors.add("question_2".to_sym, "must be unique.")
    end

    self.security_questions.each do |security_question|
      if security_question.question.blank?
        self.errors.add("question_#{security_question.order + 1}".to_sym, "is required.")
      end
      if security_question.answer.blank?
        self.errors.add("answer_#{security_question.order + 1}".to_sym, "is required.")
      end
    end
  end

  def acceptable_id_files
    return unless id_file_front.attached? || id_file_back.attached?

    unless id_file_front.blob.byte_size <= 1.megabyte
      errors.add(:id_file_front, "is too big")
    end
  
    unless id_file_back.blob.byte_size <= 1.megabyte
      errors.add(:id_file_back, "is too big")
    end
  
    acceptable_types = ["image/jpeg", "image/png", "application/pdf"] 
    
    unless acceptable_types.include?(id_file_front.content_type)
      errors.add(:id_file, "must be a JPEG or PNG")
    end

    unless acceptable_types.include?(id_file_back.content_type)
      errors.add(:id_file, "must be a JPEG or PNG")
    end
  end

  def acceptable_signature_id
    return unless signature_id.attached?
  
    unless signature_id.blob.byte_size <= 1.megabyte
      errors.add(:signature_id, "is too big")
    end
  
    acceptable_types = ["image/jpeg", "image/png", "application/pdf"] 
    
    unless acceptable_types.include?(signature_id.content_type)
      errors.add(:signature_id, "must be a JPEG or PNG")
    end
  end

  def mobile_otp_valid
    self.mobile_validated = true
    # if self.authenticate_otp(self.mobile_otp_code)
    #   self.mobile_validated = true
    # else
    #   self.mobile_validated = false 
    #   errors.add(:base, "OTP is invalid.")
    # end
  end

  def email_otp_valid
    self.email_validated = true
    # if self.authenticate_otp(self.email_otp_code)
    #   self.email_validated = true
    # else
    #   self.email_validated = false 
    #   errors.add(:base, "OTP is invalid.")
    # end
  end

end
