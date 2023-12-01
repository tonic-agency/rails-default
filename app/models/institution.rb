class Institution < ApplicationRecord
  has_many :settlement_accounts
  validates :name, presence: true
end
