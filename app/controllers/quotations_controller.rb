class QuotationsController < ApplicationController

  # Creates a quotation in the database
  def create

    # Creates a quotation with code and a placeholder premium
    quotation = Quotation.new(premium:300,calculation_date: Date.current,code:generate_code)

    if quotation.save
      # Build a person, policy and vehicle from the params using the quotation
      person = quotation.build_person(person_params)
      policy = quotation.build_policy(policy_params)
      vehicle = quotation.build_vehicle(vehicle_params)
      incidents = []
      # If there are incidents get them from the params and add them to the incidents array
      if(params[:number_incidents].to_i>0)
        (1..params[:number_incidents].to_i).each do |i|
          incident_params = {incident_date: params[("incident_date#{i}").to_sym],claim_sum: params[("claim_sum#{i}").to_sym],
                incident_type: params[("incident_type#{i}").to_sym],description: params[("description#{i}").to_sym]}
          temp = quotation.incidents.build(incident_params)
          incidents.push(temp)
        end
      end

      # If all models save and the quotation premium updates
      if(person.save && policy.save && vehicle.save && incidents.each {|i| i.save} && quotation.update_attributes(premium: create_premium(quotation)))
          # Send a mail to the user with the retrieval code
          QuotationMailer.send_code(quotation).deliver
          # Get details and render them in the response
          details = get_details(quotation,quotation.person,quotation.policy,quotation.vehicle,quotation.incidents)
          render json: details
      # Else something didn't save or premium didn't update
      else
        # Destroy the quotation in the database (will destroy all associations)
        quotation.destroy
        # Render an error in the response with status code 400
        render json: get_error("The form data was incorrect. Please try again."),status:400
      end

    # Quotation didn't save, so render error in the response with status code 400
    else
        render json: get_error("The form data was incorrect. Please try again."),status:400
    end

  end

  # Retrieves a quotation from the database
  def retrieve

    # Find the quote with the given code, returns nil if none could be found
    quote = Quotation.find_by_code(params[:code])
    # If quote is not nil and the given email matches
    if(quote!=nil && quote.person.email == (params[:email]))
      # Get details and render them in response
      details = get_details(quote,quote.person,quote.policy,quote.vehicle,quote.incidents)
      render json: details
    # Else quote was not found or email wrong so render an error message and status 400
    else
      render json: get_error("No quote was found with that quote and email combination. Please check your code and try again."),status:400
    end

  end

  # Private methods the controller uses
  private

    # Uses only the params the person model uses
    def person_params
      params.permit(:title,:forename,:surname,:email,:dob,:telephone,:street,:city,:county,:postcode,:license_type,
                                     :license_period,:occupation,:number_incidents)
    end

    # Uses only the params the policy model uses
    def policy_params
      params.permit(:excess,:breakdown_cover,:windscreen_cover)
    end

    # Uses only the params the vehicle model uses
    def vehicle_params
      params.permit(:registration,:mileage,:estimated_value,:parking,:start_date)
    end

    # Returns a hash containing all the details the user supplied, along with details the underwriter needs to send back
    def get_details(quotation,person,policy,vehicle,incidents)

      underwriter_details = {underwriter: 'DTC Insurance Underwriter',premium: quotation.premium}
      person_hash = {
          title: person[:title],
          forename: person[:forename],
          surname: person[:surname],
          email: person[:email],
          dob: person[:dob],
          telephone: person[:telephone],
          street: person[:street],
          city: person[:city],
          county: person[:county],
          postcode: person[:postcode],
          license_type: person[:license_type],
          license_period: person[:license_period],
          occupation: person[:occupation],
          number_incidents: person[:number_incidents]
      }
      policy_hash = {
          excess: policy[:excess],
          breakdown_cover: policy[:breakdown_cover],
          windscreen_cover: policy[:windscreen_cover]
      }
      vehicle_hash = {
          registration: vehicle[:registration],
          mileage: vehicle[:mileage],
          estimated_value: vehicle[:estimated_value],
          parking: vehicle[:parking],
          start_date: vehicle[:start_date]
      }
      incidents_hash = {}
      if(person[:number_incidents].to_i>0)
        (1..person[:number_incidents].to_i).each do |i|
            incidents_hash[:"incident_date#{i}"] = incidents[i-1][:incident_date]
            incidents_hash[:"claim_sum#{i}"] = incidents[i-1][:claim_sum]
            incidents_hash[:"incident_type#{i}"] = incidents[i-1][:incident_type]
            incidents_hash[:"description#{i}"] = incidents[i-1][:description]
          end
      end
      full_details = underwriter_details.merge(person_hash).merge(vehicle_hash).merge(incidents_hash).merge(policy_hash)
      return full_details

    end

    # Returns a hash of the underwriter's name and an error message
    def get_error(error)
      return {underwriter: 'DTC Insurance Underwriter', error: error}
    end

    # The code to create a premium. Demonstrates how we can use the supplied data to influence the premium.
    def create_premium(quotation)
      premium = 300
      if(quotation.person.number_incidents>0)
        premium += (quotation.person.number_incidents)*100
        quotation.incidents.each  do  |i|
          if(i.incident_type == "Head on collision")
            premium += 100
          elsif(i.incident_type == "Single vehicle collision")
            premium +=75
          else
            premium += 85
          end
        end
      end
      if(quotation.person.license_period < 3)
        premium += 50
      end
      if(quotation.policy.breakdown_cover == "At home")
        premium += 20
      elsif(quotation.policy.breakdown_cover == "Roadside")
        premium += 50
      elsif(quotation.policy.breakdown_cover == "European")
        premium += 100
      end
      if(quotation.policy.windscreen_cover == "Yes")
        premium += 30
      end
      if(quotation.vehicle.parking == "On a driveway")
        premium += 15
      elsif(quotation.vehicle.parking == "On a street")
        premium += 30
      end

      return premium
    end

    # Generates a random 8 letter code. If the code already exists as a code, (by some miracle), call the method again
    def generate_code
      code = (0...8).map { (65 + rand(26)).chr }.join.downcase
      if ((Quotation.find_by_code(code))==nil)
        return code

      else
        generate_code
      end
    end

end