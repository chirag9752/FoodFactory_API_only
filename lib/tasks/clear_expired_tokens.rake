# lib/tasks/clear_expired_tokens.rake
  namespace :jwt do
    desc "Clear expired JWT tokens from the blacklist"
    task clear_expired: :environment do
      JwtBlacklist.expired.delete_all
      puts "Expired tokens cleared from blacklist"
    end
  end
  