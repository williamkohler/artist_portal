module CalendarListHelper

  def month_array (options = {})
    date = options[:date] || Date.today
    month = Array.new
    first = date.beginning_of_month
    last = date.end_of_month
    (first..last).each do |day|
      month << day
    end
    return month
  end
end
