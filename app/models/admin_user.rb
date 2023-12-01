class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
  
  has_many :transaction_approvals

  def name
    "#{self.first_name} #{self.last_name} (#{self.email})"
  end
end
