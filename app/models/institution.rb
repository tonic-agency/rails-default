class Institution < ApplicationRecord
  has_many :settlement_accounts
  validates :name, presence: true
  validates :name, uniqueness: true, if: proc {|institution| institution.name.present? }

  def self.default 
    Institution.find_by(name: "Farmbank")
  end
end
