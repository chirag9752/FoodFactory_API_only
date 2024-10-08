class JwtBlacklist < ApplicationRecord
  # include Devise::JWT::RevocationStrategies::Denylist

  # self.table_name = 'jwt_blacklists'
  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true

  # Scope to remove expired tokens from the blacklist
  scope :expired, -> { where('exp < ?', Time.current) }
end
