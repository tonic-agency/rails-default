class ConfigVariable < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :value, :identifier, presence: true 
  validates :identifier, uniqueness: true
  validates :identifier, format: { with: /\A[a-z0-9_]+\z/, message: 'Only lowercase letters, numbers, and underscores allowed'}

  # Validation to ensure that the identifier is not updated after creation
  validate :identifier, on: :update do |record|
    if record.identifier_changed?
      record.errors.add(:identifier, 'Cannot be changed after creation to prevent system instability. Please reach out to dev team.')
    end
  end

  def whodunnit
    AdminUser.find_by(id: last_updated_by)
  end

  def self.get(identifier)
    ConfigVariable.find_by(identifier: identifier).value
  end
end