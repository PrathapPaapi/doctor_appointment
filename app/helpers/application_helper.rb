module ApplicationHelper
  def in_ist(time)
    time.in_time_zone("Chennai")
  end

  def displayable_time(time)
    in_ist(time).strftime("%I:%M %p")
  end

  def displayable_date(time)
    in_ist(time).strftime("%A, #{time.day.ordinalize}, %B")
  end
end
