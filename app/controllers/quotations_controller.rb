class QuotationsController < ApplicationController

  respond_to :html, :xml, :json

  def create

    @quotation = Quotation.new(premium:300,calculation_date: Date.current,code:generate_code)

    if @quotation.save
      person = @quotation.build_person(person_params)
      policy = @quotation.build_policy(policy_params)
      vehicle = @quotation.build_vehicle(vehicle_params)
      incidents = []
      if(params[:number_incidents].to_i>0)
        (1..params[:number_incidents].to_i).each do |i|
          incident_params = {incident_date: params[("incident_date#{i}").to_sym],claim_sum: params[("claim_sum#{i}").to_sym],
                incident_type: params[("incident_type#{i}").to_sym],description: params[("description#{i}").to_sym]}
          temp = @quotation.incidents.build(incident_params)
          incidents.push(temp)
        end
      end

      if(person.save && policy.save && vehicle.save && incidents.each {|i| i.save} && @quotation.update_attributes(premium: create_premium(@quotation)))

          QuotationMailer.send_code(@quotation).deliver
          details = get_details(@quotation,@quotation.person,@quotation.policy,@quotation.vehicle,@quotation.incidents)
          render json: details

      else
        @quotation.destroy
        render json: get_error("The form data was incorrect. Please try again."),status:400
      end

    else
        render json: get_error("The form data was incorrect. Please try again."),status:400
    end

  end

  def retrieve

    quote = Quotation.find_by_code(params[:code])
    if(quote!=nil && quote.person.email == (params[:email]))
      details = get_details(quote,quote.person,quote.policy,quote.vehicle,quote.incidents)
      render json: details
    else
      render json: get_error("No quote was found with that quote and email combination. Please check your code and try again."),status:400
    end

  end

  private

    def person_params
      params.permit(:title,:forename,:surname,:email,:dob,:telephone,:street,:city,:county,:postcode,:license_type,
                                     :license_period,:occupation,:number_incidents)
    end

    def policy_params
      params.permit(:excess,:breakdown_cover,:windscreen_cover)
    end

    def vehicle_params
      params.permit(:registration,:mileage,:estimated_value,:parking,:start_date)
    end

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