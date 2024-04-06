class User < ApplicationRecord
  has_secure_password :password, validations: true
    validates :name, presence: true, uniqueness: true
    has_many :orders
    # Associations
    has_one :profile, dependent: :destroy

    # Callbacks
    after_create :build_default_profile

    private

    def build_default_profile
      build_profile.save
    end
  end
