require 'spec_helper'

describe Quotation do

  before { @quotation = Quotation.new(premium: 1000, calculation_date: Date.new(2006,11,27), code:"C123")}

  subject { @quotation }

  it { should respond_to(:premium)}
  it { should respond_to(:calculation_date)}
  it { should respond_to(:code)}
  it { should respond_to(:person)}

  it {should be_valid}

  describe "when premium is not a number" do
    before {@quotation.premium = "hundred"}
    it {should_not be_valid}
  end

  describe "when date is nil" do
    before {@quotation.calculation_date = nil}
    it {should_not be_valid}
  end

  describe "when code is nil" do
    before {@quotation.code = nil}
    it {should_not be_valid}
  end

  describe "getting the quote from their code" do
    before {@quotation.save}
    let(:found_quote) {Quotation.find_by(code: "C123")}

    it {should eq @quotation}
  end

  describe "two quotations with same code" do

    before do
    other_quote = @quotation.dup
    other_quote.code = @quotation.code.upcase
    other_quote.save
    end
    it {should_not be_valid}
  end

   describe "person association" do

     before { @quotation.save }
     let!(:person) do
       FactoryGirl.create(:person, quotation: @quotation)
     end

     it "should destroy associated person" do

       person = @quotation.person
       @quotation.destroy
       expect(Person.where(id: person.id)).to be_empty

     end

   end

end
