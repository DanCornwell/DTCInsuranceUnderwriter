require "spec_helper"

describe QuotationMailer do

  let(:quotation) { FactoryGirl.create(:quotation)}

  before {quotation.save}

  let(:person) {FactoryGirl.create(:person, quotation: quotation)}

  describe "send code" do

    before do
      person.save
      @mail = QuotationMailer.send_code(quotation)
    end

    it "should have a subject" do
      @mail.subject.should == "DTC Underwriter - Your quotation code"
    end

    it "should have the correct receiver" do
      @mail.to.should == [quotation.person.email]
    end

    it "should have the person's name" do
      @mail.body.encoded.should match(quotation.person.forename)
      @mail.body.encoded.should match(quotation.person.surname)
    end

    it "should have the quote premium" do
      @mail.body.encoded.should match("#{quotation.premium}")
    end

    it "should have the quote code" do
      @mail.body.encoded.should match(quotation.code)
    end

    it "should deliver" do

      @mail.deliver

      sent = ActionMailer::Base.deliveries.last

      @mail.should eq sent

    end

  end

end
