require 'spec_helper'

describe QuotationsController do

  let(:person) {FactoryGirl.attributes_for(:person)}
  let(:vehicle) {FactoryGirl.attributes_for(:vehicle)}
  let(:policy) {FactoryGirl.attributes_for(:policy)}

  incident1 = {incident_date1: Date.new(2000,1,1),claim_sum1: 200,incident_type1: "Head on collision",description1:"crash"}
  incident2 = {incident_date2: Date.new(2000,1,1),claim_sum2: 200,incident_type2: "Head on collision",description2:"crash"}

  describe "posting valid data" do

    it "should create quotation with incidents" do
      post :create, person.merge(vehicle).merge(policy).merge(incident1).merge(incident2)
      expect(response.status).to eq(302)
      expect(Quotation.count).to eq 1
      expect(Person.count).to eq 1
      expect(Vehicle.count).to eq 1
      expect(Policy.count).to eq 1
      expect(Incident.count).to eq 2

    end

    it "should create quotation without incidents" do
      person[:number_incidents]=0
      post :create, person.merge(vehicle).merge(policy)
      expect(response.status).to eq(302)
      expect(Quotation.count).to eq 1
      expect(Person.count).to eq 1
      expect(Vehicle.count).to eq 1
      expect(Policy.count).to eq 1
      expect(Incident.count).to eq 0

    end

  end

  describe "posting invalid data" do

    before {person[:forename]="101010010"}

    it "should not create quotation" do
      post :create, person.merge(vehicle).merge(policy).merge(incident1).merge(incident2)
      response.should redirect_to("http://protected-bastion-3103.herokuapp.com/error?error=Form data was incorrect.")
      expect(Quotation.count).to eq 0
      expect(Person.count).to eq 0
      expect(Vehicle.count).to eq 0
      expect(Policy.count).to eq 0
      expect(Incident.count).to eq 0

    end
  end

  describe "generating code and premium" do

    before {post :create, person.merge(vehicle).merge(policy).merge(incident1).merge(incident2)}

    it "should generate a code" do
      code = Quotation.first.code
      code.should have(8).characters
    end

    it "should generate a premium" do
      premium = Quotation.first.premium
      premium.should be >= 300
    end
  end

end