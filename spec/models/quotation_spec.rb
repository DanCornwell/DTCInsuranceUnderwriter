require 'spec_helper'

describe Quotation do

  before(:each) {@quotation = Quotation.new(premium: 1000, calculation_date: Date.new(2006,11,27), code:"C123")}

  subject { @quotation }

  it { should respond_to(:premium)}
  it { should respond_to(:calculation_date)}
  it { should respond_to(:code)}
  it { should respond_to(:person)}
  it { should respond_to(:policy)}
  it { should respond_to(:vehicle)}
  it { should respond_to(:incidents)}

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

    it {found_quote.should eq @quotation}
  end

  describe "two quotations with same code" do
    before do
     other_quote = @quotation.dup
     other_quote.save
    end

    it { should_not be_valid}
  end

   describe "associations" do

     before {@quotation.save}
     let(:person) {FactoryGirl.create(:person, quotation: @quotation)}
     let(:policy) {FactoryGirl.create(:policy, quotation: @quotation)}
     let(:vehicle) {FactoryGirl.create(:vehicle, quotation: @quotation)}
     let(:incident1) {FactoryGirl.create(:incident, quotation: @quotation)}
     let(:incident2) {FactoryGirl.create(:incident, quotation: @quotation)}
     let(:incident3) {FactoryGirl.create(:incident, quotation: @quotation)}

     it "Quotation should have associations" do
       person.save
       policy.save
       vehicle.save
       incident1.save
       incident2.save
       incident3.save

       Person.where(quotation_id: @quotation.id).should exist
       Policy.where(quotation_id: @quotation.id).should exist
       Vehicle.where(quotation_id: @quotation.id).should exist
       incidents = @quotation.incidents.to_a
       expect(incidents).not_to be_empty
       expect(incidents.length).to eq 3
       incidents.each do |incident|
         Incident.where(id: incident.id).should exist
        (incident.quotation_id).should eq @quotation.id
       end

     end

     it "should destroy all associations when deleted" do
       @quotation.destroy
       Person.where(quotation_id: @quotation.id).should_not exist
       Policy.where(quotation_id: @quotation.id).should_not exist
       Vehicle.where(quotation_id: @quotation.id).should_not exist
       incidents = @quotation.incidents.to_a
       incidents.each do |incident|
         Incident.where(id: incident.id).should_not exist
       end
     end

  end

end
