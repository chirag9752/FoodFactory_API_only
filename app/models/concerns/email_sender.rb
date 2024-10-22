module EmailSender
  extend ActiveSupport::Concern

  included do
    after_create :send_welcome_email
  end

  private
  
  def send_welcome_email
    UserMailerJob.perform_later(self)
  end
end