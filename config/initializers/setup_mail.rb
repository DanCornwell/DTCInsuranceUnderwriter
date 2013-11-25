ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "protected-bastion-3103.herokuapp.com",
    :user_name            => "dtcunderwriter",
    :password             => "overwriter",
    :authentication       => "plain",
    :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "protected-bastion-3103.herokuapp.com"
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?