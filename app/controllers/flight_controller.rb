class FlightController < ApplicationController
  def index
    flights = Flight.where({f_type: params[:filter]}).order("exact_time asc")
    render json: flights
  end
end
