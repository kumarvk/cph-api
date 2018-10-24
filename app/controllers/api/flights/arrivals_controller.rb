class Api::Flights::ArrivalsController < ApplicationController
  def index
    flights = Arrival.page(params[:page]).order("exact_time asc")
    render json: {flights: flights, total_count: flights.total_count}
  end

  def search
    flights = Arrival.filter(params).page(params[:page])
    render json: {flights: flights, total_count: flights.total_count}
  end
end
