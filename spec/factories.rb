FactoryGirl.define do

  factory :quotation do

    premium     3000
    calculation_date    Date.new(2000,1,1)
    sequence(:code) {|n| "code#{n}"}

  end

  factory :person do

    title "Mr"
    forename "John"
    surname "Jackson"
    email "jj55@aber.ac.uk"
    dob Date.new(1990,1,1)
    telephone '07785728345'
    street "11 Typical Street"
    city "Simcity"
    county "Brekinshire"
    postcode "BS4 8KL"
    license_type "Full"
    license_period 6
    occupation "builder"
    number_incidents 2
    quotation

  end

  factory :policy do

    excess 25
    breakdown_cover "Roadside"
    windscreen_cover "Yes"
    quotation

  end

  factory :vehicle do

    registration "REG5"
    mileage 10000
    estimated_value 20000
    parking "On a driveway"
    start_date Date.new(2015,1,3)
    quotation

  end

  factory :incident do

    incident_date Date.new(2000,1,1)
    claim_sum 300
    incident_type "Single vehicle collision"
    description "Its a description"
    quotation

  end

end