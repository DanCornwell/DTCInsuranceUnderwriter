FactoryGirl.define do

  factory :quotation do

    premium     3000
    calculation_date    Date.new(2000,1,1)
    sequence(:code) {|n| "code#{n}" }

  end

  factory :person do

    quotation
    forename "John"
    surname "Jackson"
    email "jj55@aber.ac.uk"
    dob Date.new(2000,1,1)
    telephone '07785728345'
    street "11 Typical Street"
    city "Simcity"
    county "Brekinshire"
    postcode "BS4 8KL"
    license_type "full"
    license_period 6
    occupation "builder"
    number_incidents 2

  end

end