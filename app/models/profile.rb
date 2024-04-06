class Profile < ApplicationRecord
  belongs_to :user

  after_initialize :set_defaults, unless: :persisted?

  private

  def set_defaults
    self.location ||= 'Unknown Location'
    self.bio ||= 'My bio'
    self.birthdate ||= '2000-01-01'

  end

end
