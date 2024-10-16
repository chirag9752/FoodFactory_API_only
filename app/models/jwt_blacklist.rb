class JwtBlacklist < ApplicationRecord
  validates :jti, presence: true, uniqueness: true
  validates :exp, presence: true

  # Scope to remove expired tokens from the blacklist
  scope :expired, -> { where('exp < ?', Time.current) }
end
