class QuotationMailer < ActionMailer::Base

    # Sends an email to the user

    default from: "no-reply@dtcinsuranceunderwriter.com"

     def send_code(quotation)
       @quotation = quotation
       mail(:to => quotation.person.email, :subject => "DTC Underwriter - Your quotation code")
     end

end
