class SecurityQuestion < ApplicationRecord
  belongs_to :kyc_onboarding

  enum questions: {
    0 => "What is your mother's maiden name?",
    1 => "What is your favorite food?",
    2 => "What is your favorite color?",
    3 => "What is your favorite movie?",
    4 => "What is your favorite song?",
    5 => "What is your favorite book?",
  }
end
