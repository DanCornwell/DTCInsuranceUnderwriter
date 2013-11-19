require 'spec_helper'

describe Vehicle do

  let(:quotation) { FactoryGirl.create(:quotation)}

  before (:each) do

    @vehicle = quotation.create_vehicle(registration:"REG123",mileage:5000,estimated_value:10000,parking:"On street",
                    start_date:Date.current)

  end

  subject{@vehicle}

  it {should respond_to(:quotation_id)}
  it {should respond_to(:quotation)}
  its(:quotation) {should eq quotation}

  it {should respond_to(:registration)}
  it {should respond_to(:mileage)}
  it {should respond_to(:estimated_value)}
  it {should respond_to(:parking)}
  it {should respond_to(:start_date)}

  it {should be_valid}

  describe "when quotation id is nil" do
    before {@vehicle.quotation_id = nil}
    it {should_not be_valid}

  end

  describe "when registration is nil" do
    before {@vehicle.registration = nil}
    it {should_not be_valid}

  end

  describe "when mileage is not a number" do
    before {@vehicle.mileage = "thousand"}
    it {should_not be_valid}

  end

  describe "when estimated value is 0" do
    before {@vehicle.estimated_value = 0}
    it {should_not be_valid}

  end

  describe "when estimated value is not a number" do
    before {@vehicle.estimated_value = "thousand"}
    it {should_not be_valid}

  end

  describe "when parking value is not valid" do
    before {@vehicle.parking = "in a alleyway"}
    it {should_not be_valid}

  end

  describe "when start date is in the past" do
    before {@vehicle.start_date = Date.new(2000,2,3)}
    it {should_not be_valid}

  end

  describe "vehicle quotation id equals quotation id" do
    its(:quotation_id) {should eq quotation.id}
  end

  describe "retrieval via quotation id" do

    it "should find vehicle connecting to quotation" do
      Vehicle.where(quotation_id: quotation.id).should exist
    end

    it "should not find vehicle that doesn't exist" do
      Vehicle.where(quotation_id: 14).should_not exist
    end

  end

end
