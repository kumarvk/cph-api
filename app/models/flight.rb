class Flight < ApplicationRecord
  paginates_per 5
  def self.filter(params)
    cond = ""
    values = {}
    filter = params[:filter]

    if filter["text"].present?
      cond = "(destination ~* :s OR airline ~* :s OR status ~* :s OR flight_no ~* :s) "
      values[:s] = filter["text"]
    end

    if filter["time"].present? && filter["time"] != "Time"
      cond += "AND " if cond.present?
      cond += "(exact_time::time > :t)"
      values[:t] = filter["time"]
    end

    where(cond, values).order("exact_time asc")
  end
end
