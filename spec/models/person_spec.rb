require 'spec_helper'

describe Person do

  let(:quotation) { FactoryGirl.create(:quotation)}

  before(:each) do

    @person = quotation.create_person(title: 'Mr',forename: 'Jack',surname: 'Johnson',email:'jj1@aber.ac.uk',
              dob: Date.new(1990,12,8),telephone: '07962453187',street: 'park lane', city: 'liberty city', county: 'Dari',
              postcode: 'DR45 7TY',license_type: 'Full',license_period: 4,occupation: 'teacher',number_incidents: 0)

  end
  subject {@person}

  it {should respond_to(:quotation_id)}
  it {should respond_to(:quotation)}
  its(:quotation) {should eq quotation}

  it {should respond_to(:forename)}
  it {should respond_to(:surname)}
  it {should respond_to(:email)}
  it {should respond_to(:dob)}
  it {should respond_to(:telephone)}
  it {should respond_to(:street)}
  it {should respond_to(:city)}
  it {should respond_to(:county)}
  it {should respond_to(:postcode)}
  it {should respond_to(:license_type)}
  it {should respond_to(:license_period)}
  it {should respond_to(:occupation)}
  it {should respond_to(:number_incidents)}

  it {should be_valid}

  describe "when quotation id is not present" do
    before { @person.quotation_id = nil }
    it { should_not be_valid }
  end


  describe "when forename is not valid format" do
    before { @person.forename = 'num98'}
    it { should_not be_valid }
  end

  describe "when surname is not valid format" do
    before { @person.surname = '@gfoiu'}
    it { should_not be_valid }
  end

  describe "when email is not valid format" do
    before { @person.email = 'invalid@.m'}
    it { should_not be_valid }
  end

  describe "when dob is not 17 years ago" do
    before { @person.dob = Date.new(2007,11,8)}
    it { should_not be_valid }
  end

  describe "when telephone is not valid format" do
    before { @person.telephone = '09863tel'}
    it { should_not be_valid }
  end

  describe "when street is not valid format" do
    before { @person.street = '! cr[]'}
    it { should_not be_valid }
  end

  describe "when city is not valid format" do
    before { @person.city = 'district 9'}
    it { should_not be_valid }
  end

  describe "when county is not valid format" do
    before { @person.county = 'county*'}
    it { should_not be_valid }
  end

  describe "when forename is not valid format" do
    before { @person.postcode = 'KL9 76D'}
    it { should_not be_valid }
  end

  describe "when license type is not valid format" do
    before { @person.license_type = 'yes'}
    it { should_not be_valid }
  end

  describe "when license period is not a number" do
    before { @person.license_period = 'eight'}
    it { should_not be_valid }
  end

  describe "when number incidents is not a number" do
    before { @person.number_incidents = 'ten'}
    it { should_not be_valid }
  end

  describe "person quotation id equals quotation id" do
    its(:quotation_id) {should eq quotation.id}
  end

  describe "retrieval via quotation id" do

    it "should find person connecting to quotation" do
      Person.where(quotation_id: quotation.id).should exist
    end

    it "should not find person that doesn't exist" do
      Person.where(quotation_id: 18).should_not exist
    end

  end

end
