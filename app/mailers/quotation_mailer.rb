class QuotationMailer < ActionMailer::Base

    default from: "no-reply@dtcinsuranceunderwriter.com"

     def send_code(quotation)
       @quotation = quotation
       mail(:to => quotation.person.email, :subject => "DTC Underwriter - Your quotation code")
     end

end
