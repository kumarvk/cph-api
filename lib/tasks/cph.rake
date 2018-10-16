namespace :cph do
  desc "load flights of cph"
  task flights: :environment do
    get_page("https://www.cph.dk/en/flight-information/arrivals", "arrivals");
    get_page("https://www.cph.dk/en/flight-information/departures", "departures");
  end
end

def get_page(url, type)
  page = Nokogiri::HTML(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
  mapped_flights(page, type)
end

def mapped_flights(page, type)
  results = []
  page.css(".stylish-table__row--body").each do |row|
    flight = {}
    flight[:f_type] = type
    flight[:airline] = row.css(".v--desktop-only")[1].try(:text).try(:strip)
    flight[:exact_time] = row.css(".flights__table__col--time").text.try(:strip).split("\n")[0].try(:strip)
    flight[:expected_time] = row.css(".flights__table__col--time").text.try(:strip).split("\n")[1].try(:strip)
    destination = row.css(".flights__table__col--destination").text.try(:strip).split("\n")
    flight[:destination] = destination[0].try(:strip)
    flight[:status] = row.css(".stylish-table__cell")[-2].try(:text).try(:strip)
    results << flight
  end
  Flight.create(results)
end
