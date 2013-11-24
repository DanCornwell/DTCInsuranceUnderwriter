class QuotationMailer < ActionMailer::Base

     def send_code(quotation)
       @quotation = quotation
       mail(:to => quotation.person.email, :subject => "DTC Underwriter - Your quotation code", :from => "dtcunderwriter@gmail.com")
     end

end
