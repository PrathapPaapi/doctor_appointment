class Doctor < ApplicationRecord

  serialize :slots, Array
  after_create :create_slots

  class Schedule
    attr_accessor :time, :present, :available
    def initialize(time)
      @time = time
      @present = false
      @available = true
    end
  end
  
  def create_slots
    6.times do |s|
      slots << add_slots(s)
    end
    p slots.length
  end

  def add_slots(next_day)
    day_slots = []
    first_period_start_time = DateTime.parse("12:00")
    first_period_end_time = DateTime.parse("13:00")
    second_period_start_time = DateTime.parse("14:00")
    second_period_end_time = DateTime.parse("16:00")
    for i in 0..23
      date = DateTime.parse("#{i}:00") + next_day.day
      day_slots[i] = Schedule.new(date)
      if ((day_slots[i].time.hour >= first_period_start_time.hour && day_slots[i].time.hour < first_period_end_time.hour) ||
        (day_slots[i].time.hour >= second_period_start_time.hour && day_slots[i].time.hour < second_period_end_time.hour))
        day_slots[i].present = true
      end
    end
    day_slots
  end
end
