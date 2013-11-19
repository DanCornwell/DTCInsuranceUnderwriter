require 'spec_helper'

describe Policy do

  let(:quotation) { FactoryGirl.create(:quotation)}

  before(:each) do

    @policy = quotation.create_policy(excess:20,breakdown_cover:'At home',windscreen_cover:"No")

  end

  subject{@policy}

  it {should respond_to(:quotation_id)}
  it {should respond_to(:quotation)}
  its(:quotation) {should eq quotation}

  it {should respond_to(:excess)}
  it {should respond_to(:breakdown_cover)}
  it {should respond_to(:windscreen_cover)}

  it {should be_valid}

  describe "when quotation id is nil" do
    before {@policy.quotation_id = nil}
    it {should_not be_valid}

  end

  describe "when policy is not present" do
    before {@policy.excess = nil}
    it { should_not be_valid }

  end

  describe "when breakdown is not valid" do
    before {@policy.breakdown_cover = "sometimes"}
    it { should_not be_valid }

  end

  describe "when windscreen is not valid" do
    before {@policy.windscreen_cover = "no thanks"}
    it { should_not be_valid }

  end

  describe "policy quotation id equals quotation id" do
    its(:quotation_id) {should eq quotation.id}
  end

  describe "retrieval via quotation id" do

    it "should find policy connecting to quotation" do
      Policy.where(quotation_id: quotation.id).should exist
    end

    it "should not find policy that doesn't exist" do
      Policy.where(quotation_id: 14).should_not exist
    end

  end

end
