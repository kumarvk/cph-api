namespace :cph do
  desc "load flights of cph"
  task flights: :environment do
    (DateTime.now..DateTime.now + 2.days).each do |date|
      Rails.logger.info "====================================================="
      Rails.logger.info "Import all arrival flights of Copenhagen Airport's"
      get_page("https://www.cph.dk/en/flight-information/arrivals?q=&date=#{get_url(date)}", "Arrival", date);

      Rails.logger.info "====================================================="
      Rails.logger.info "Import all departure flights of Copenhagen Airport's"
      get_page("https://www.cph.dk/en/flight-information/departures?q=&date=#{get_url(date)}", "Departure", date);
    end
  end
end

def get_page(url, type, date)
  page = Nokogiri::HTML(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))
  mapped_flights(page, type, date)
end

def mapped_flights(page, type, date)
  results = []
  page.css(".stylish-table__row--body").each do |row|
    flight = {}
    flight[:type] = type
    flight[:airline] = row.css(".v--desktop-only")[1].try(:text).try(:strip)
    flight[:date] = date
    flight[:exact_time] = row.css(".flights__table__col--time").text.try(:strip).split("\n")[0].try(:strip)
    flight[:expected_time] = row.css(".flights__table__col--time").text.try(:strip).split("\n")[1].try(:strip)
    destination = row.css(".flights__table__col--destination").text.try(:strip).split("\n")
    flight[:destination] = destination[0].try(:strip) + " " + destination[1].try(:strip)
    flight[:flight_no] = destination[2].try(:strip)
    flight[:status] = row.css(".stylish-table__cell")[-2].try(:text).try(:strip)
    existing_flight = Flight.where(flight_no: flight[:flight_no], date: date).first
    next check_or_update(existing_flight, flight) if existing_flight.present?
    results << flight
  end
  Flight.create(results)
  Rails.logger.info "No of #{results.count} recored successfully imported"
end

def check_or_update(existing_flight, flight)
  is_change = false
  flight.each do |key, value|
    if [:exact_time, :expected_time].include?(key)
      is_change = true if get_time(existing_flight[key]) != value
    else
      is_change = true if existing_flight[key] != value
    end
    break if is_change
  end
  return unless is_change
  Rails.logger.info existing_flight.attributes
  Rails.logger.info flight
  Rails.logger.info "Flight no #{existing_flight.flight_no} recored successfully updated"
  existing_flight.update_attributes(flight)
end

def get_time(value)
  value.present? ? DateTime.parse(value.to_s).strftime("%H:%M") : nil
end

def get_date(date = Date.today)
  DateTime.parse(date.to_s).strftime("%d - %m - %Y")
end

def get_url(date)
  URI.encode(get_date(date)) + "&time=00"
end
