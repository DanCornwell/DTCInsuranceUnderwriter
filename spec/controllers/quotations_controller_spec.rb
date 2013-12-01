require 'spec_helper'

describe QuotationsController do

  let(:person) {FactoryGirl.attributes_for(:person)}
  let(:vehicle) {FactoryGirl.attributes_for(:vehicle)}
  let(:policy) {FactoryGirl.attributes_for(:policy)}

  incident1 = {incident_date1: Date.new(2000,1,1).strftime("%Y-%m-%d"),claim_sum1: 200,incident_type1: "Head on collision",description1:"crash"}
  incident2 = {incident_date2: Date.new(2000,1,1).strftime("%Y-%m-%d"),claim_sum2: 200,incident_type2: "Head on collision",description2:"crash"}

  describe "posting valid data" do

    it "should create quotation with incidents and respond with json" do
      post :create, person.merge(vehicle).merge(policy).merge(incident1).merge(incident2)
      expect(response.code == 200)
      expect(Quotation.count).to eq 1
      expect(Person.count).to eq 1
      expect(Vehicle.count).to eq 1
      expect(Policy.count).to eq 1
      expect(Incident.count).to eq 2
      parsed_response = JSON.parse(response.body).symbolize_keys
      underwriter_details = {underwriter: 'DTC Insurance Underwriter',premium: 795}
      parsed_response.should == underwriter_details.merge(person).merge(vehicle).merge(incident1).merge(incident2).merge(policy)


    end

    it "should create quotation without incidents and respond with json" do
      person[:number_incidents]=0
      post :create, person.merge(vehicle).merge(policy)
      expect(response.code == 200)
      expect(Quotation.count).to eq 1
      expect(Person.count).to eq 1
      expect(Vehicle.count).to eq 1
      expect(Policy.count).to eq 1
      expect(Incident.count).to eq 0
      parsed_response = JSON.parse(response.body).symbolize_keys
      underwriter_details = {underwriter: 'DTC Insurance Underwriter',premium: 395}
      parsed_response.should == underwriter_details.merge(person).merge(vehicle).merge(policy)

    end

  end

  describe "posting invalid data" do

    before {person[:forename]="101010010"}

    it "should not create quotation" do
      post :create, person.merge(vehicle).merge(policy).merge(incident1).merge(incident2)
      expect(response.code == 400)
      parsed_response = JSON.parse(response.body).symbolize_keys
      parsed_response.should == {underwriter: 'DTC Insurance Underwriter', error: "The form data was incorrect. Please try again."}
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

  describe "retrieving a quote" do

    before do
      post :create, person.merge(vehicle).merge(policy).merge(incident1).merge(incident2)
      expect(response.code == 200)
      @retrieval_code = Quotation.first.code
      @email = person[:email]
    end

    it "should retrieve a quote and respond with json" do

      post :retrieve, {code: @retrieval_code, email: @email}
      expect(response.code == 200)
      parsed_response = JSON.parse(response.body).symbolize_keys
      underwriter_details = {underwriter: 'DTC Insurance Underwriter',premium: 795}
      parsed_response.should == underwriter_details.merge(person).merge(vehicle).merge(incident1).merge(incident2).merge(policy)

    end

    it "should not retrieve a quote with incorrect code or email" do

      post :retrieve, {code: 'fake', email: @email}
      expect(response.code == 400)
      parsed_response = JSON.parse(response.body).symbolize_keys
      parsed_response.should == {underwriter: 'DTC Insurance Underwriter', error: "No quote was found with that quote and email combination. Please check your code and try again."}

      post :retrieve, {code: @retrieval_code, email: 'email@email.com'}
      expect(response.code == 400)
      parsed_response = JSON.parse(response.body).symbolize_keys
      parsed_response.should == {underwriter: 'DTC Insurance Underwriter', error: "No quote was found with that quote and email combination. Please check your code and try again."}

      post :retrieve, {code: 'fake', email: 'email@email.com'}
      expect(response.code == 400)
      parsed_response = JSON.parse(response.body).symbolize_keys
      parsed_response.should == {underwriter: 'DTC Insurance Underwriter', error: "No quote was found with that quote and email combination. Please check your code and try again."}

    end

  end

end