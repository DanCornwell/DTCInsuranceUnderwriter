class IncidentsController < ApplicationController

  def create
    @incident = current_quote.build_incident(policy_params)
    if @incident.save

    end
  else
    # do something
  end

  private

  def person_params
    params.require(:incident).permit(:content)
  end

end