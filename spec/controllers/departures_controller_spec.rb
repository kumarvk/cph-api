require 'rails_helper'

RSpec.describe  Api::Flights::DeparturesController, type: :controller do
  describe "get_models_for_make" do
    before(:each) do
      4.times {FactoryBot.create(:flight, airline: 'Test1 Air', type: 'Departure')}
      7.times {FactoryBot.create(:flight, airline: 'qwerty Air', type: 'Departure')}
    end

    it "get all departures flight" do
      get :index, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(5)
      expect(data["total_count"]).to eq(11)
    end

    it "get all departures flight when time filter applied" do
      Departure.update_all exact_time: Time.zone.parse('09:00')
      get :search, params: {filter: {time: "08:00"}}, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(5)
      expect(data["total_count"]).to eq(11)
    end

    it "get all departures flight for page 2 when time and text filter applied" do
      Departure.update_all exact_time: Time.zone.parse('09:00')
      get :search, params: {filter: {text: 'qwerty', time: "08:00"}, page: 2}, format: :json
      data = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(data["flights"].count).to eq(2)
      expect(data["total_count"]).to eq(7)
    end
  end
end
