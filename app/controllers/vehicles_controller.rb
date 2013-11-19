class VehiclesController < ApplicationController

  def create
    @vehicle = current_quote.build_vehicle(vehicle_params)
    if @vehicle.save

    end
  else
    # do something
  end

  private

  def person_params
    params.require(:vehicle).permit(:content)
  end

end