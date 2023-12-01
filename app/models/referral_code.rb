class ReferralCode < ApplicationRecord
  belongs_to :user
  validates :code, uniqueness: true
  validates :user_id, uniqueness: true
  
  before_create :generate_code

  # The length of 5 characters should provide 60,466,176 possible combinations
  # only using uppercase letters - number of possible letters = 26
  # 10 possible digits from 0-9 
  # 26 + 10 = 36 possible characters 
  # (36^5) = 60,466,176 possible combinations
  # for 4 character codes there is a possible of:
  # (36^4) = 1,679,616 possible combinations
  CODE_LENGTH = 5
  
  private
  def generate_code
    loop do 
      # only uppercase letters and numbers - 36 characters total
      characters = [('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
      code = Array.new(CODE_LENGTH) { characters.sample }.join
      
      break self.code = code unless ReferralCode.exists?(code: code)
    end 
  end
  
end
