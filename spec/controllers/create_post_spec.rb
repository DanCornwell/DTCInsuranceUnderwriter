require 'spec_helper'

describe QuotationsController do

  let(:person) {FactoryGirl.attributes_for(:person)}
  let(:vehicle) {FactoryGirl.attributes_for(:vehicle)}
  let(:policy) {FactoryGirl.attributes_for(:policy)}

  incident1 = {incident_date1: Date.new(2000,1,1),claim_sum1: 200,incident_type1: "Head on collision",description1:"crash"}
  incident2 = {incident_date2: Date.new(2000,1,1),claim_sum2: 200,incident_type2: "Head on collision",description2:"crash"}

  it "creates quotation" do

    post :create, person.merge(vehicle).merge(policy).merge(incident1).merge(incident2)
    expect(response.status).to eq(302)
    expect(Quotation.count).to eq 1
    expect(Person.count).to eq 1
    expect(Vehicle.count).to eq 1
    expect(Policy.count).to eq 1
    expect(Incident.count).to eq 2

  end

end