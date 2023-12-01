class Referral < ApplicationRecord
  belongs_to :referrer, class_name: "User", :foreign_key => "from_id"
  belongs_to :referred_user, class_name: "User", :foreign_key => "to_id"
  belongs_to :referral_scheme

  validates :referrer, presence: true
  validates :referred_user, presence: true
  validates :referral_scheme, presence: true
  validates_uniqueness_of :referred_user, scope: :to_id

  validate :referrer_is_not_referred_user

  def referrer_is_not_referred_user
    if referrer == referred_user
      errors.add(:referred_user, "cannot be the same as referrer")
    end
  end

end