class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.subject}"
    message.to = "dac28@aber.ac.uk"
  end
end