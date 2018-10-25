class Flight < ApplicationRecord
  paginates_per 5
  def self.filter(params)
    cond = ""
    values = {}
    filter = params[:filter].is_a?(String) ? JSON.parse(params[:filter]) : params[:filter]

    if filter["text"].present?
      cond = "(destination ~* :s OR airline ~* :s OR status ~* :s OR flight_no ~* :s) "
      values[:s] = filter["text"]
    end

    if filter["time"].present? && filter["time"].downcase! != "time"
      cond += "AND " if cond.present?
      cond += "(exact_time::time >= :t) "
      values[:t] = filter["time"]
    end

    if filter["date"].present?
      cond += "AND " if cond.present?
      cond += "(date::date = :d)"
      values[:d] = filter["date"]
    end

    where(cond, values).order("exact_time asc")
  end
end
