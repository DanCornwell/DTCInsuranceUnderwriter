ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "dtcinsuranceunderwriter.herokuapp.com",
    :user_name            => "dtcinsuranceunderwriter",
    :password             => ENV["PASSWORD"],
    :authentication       => "plain",
    :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "dtcinsuranceunderwriter.herokuapp.com"
