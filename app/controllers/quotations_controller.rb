class QuotationsController < ApplicationController

  respond_to :html, :xml, :json

  def create

    @quotation = Quotation.new(premium:create_premium,calculation_date: Date.current,code:generate_code)

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
      @quotation.premium = create_premium if(person.valid? && policy.valid? && vehicle.valid? && incidents.each {|i| i.valid?})
      if(person.save && policy.save && vehicle.save && incidents.each {|i| i.save} && @quotation.save)
        redirect_to({:protocol => 'http://protected-bastion-3103.herokuapp.com/quote'}.merge({quote: @quotation.premium}))
        #respond_with(@quotation,location: @quotation)
      else
        @quotation.destroy
        redirect_to status:400
      end

    else
      redirect_to status:400

    end

  end

  def create_premium
     return 1000
  end

  def generate_code
    code = (0...6).map { (65 + rand(26)).chr }.join.downcase
    if ((Quotation.find_by_code(code))==nil)
      return code

    else
      generate_code
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

end