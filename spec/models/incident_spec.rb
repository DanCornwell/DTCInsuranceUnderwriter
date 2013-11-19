require 'spec_helper'

describe Incident do

  let(:quotation) { FactoryGirl.create(:quotation)}

  before(:each) do

    @incident = quotation.incidents.create(incident_date: Date.new(2000,1,1),claim_sum:2000,incident_type:"Head on collision",description:"A vague, ambiguous description")

  end

  subject{@incident}

  it {should respond_to(:quotation_id)}
  it {should respond_to(:quotation)}
  its(:quotation) {should eq quotation}

  it {should respond_to(:incident_date)}
  it {should respond_to(:claim_sum)}
  it {should respond_to(:incident_type)}
  it {should respond_to(:description)}

  it {should be_valid}

  describe "when quotation id is nil" do
    before {@incident.quotation_id = nil}
    it {should_not be_valid}

  end

  describe "when claim sum is not a number" do
    before {@incident.claim_sum = "thousand"}
    it { should_not be_valid }

  end

  describe "when type is not valid" do
    before {@incident.incident_type = "crash"}
    it { should_not be_valid }

  end

  describe "when description is not valid" do
    before {@incident.description = nil}
    it { should_not be_valid }

  end

  describe "incident quotation id equals quotation id" do
    its(:quotation_id) {should eq quotation.id}
  end

  describe "retrieval via quotation id" do

    it "should find incident connecting to quotation" do
      Incident.where(quotation_id: quotation.id).should exist
    end

    it "should not find policy that doesn't exist" do
      Incident.where(quotation_id: 14).should_not exist
    end

  end

end
