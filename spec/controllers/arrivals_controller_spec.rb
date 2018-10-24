require 'rails_helper'

RSpec.describe Api::Flights::ArrivalsController, type: :controller do
  describe "fetch arrivals flight" do
    before(:each) do
      4.times {FactoryBot.create(:flight, airline: 'Test Air')}
      7.times {FactoryBot.create(:flight, airline: 'xyz Air')}
    end

    it "get all arrivals flight" do
      get :index, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(5)
      expect(data["total_count"]).to eq(11)
    end

    it "get all arrivals flight when text filter applied" do
      get :search, params: {filter: {text: "Test"}}, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(4)
      expect(data["total_count"]).to eq(4)
    end

    it "get all arrivals flight when time and text filter applied" do
      Arrival.update_all exact_time: Time.zone.parse('09:00')
      get :search, params: {filter: {text: "xyz", time: "08:00"}}, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(5)
      expect(data["total_count"]).to eq(7)
    end

    it "get all arrivals flight for page 2 when time and text filter applied" do
      Arrival.update_all exact_time: Time.zone.parse('09:00')
      get :search, params: {filter: {text: "xyz", time: "08:55"}, page: 2}, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(2)
      expect(data["total_count"]).to eq(7)
    end

    it "get all arrivals flight when no filters applied" do
      get :search, params: {filter: {text: "", time: ""}}, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(5)
      expect(data["total_count"]).to eq(11)
    end
  end
end
