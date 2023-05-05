class Doctor < ApplicationRecord
  include ApplicationHelper
  has_many :slots, dependent: :destroy

  def slots_for_day day
    slots.where("slot_time > ? AND slot_time < ?", day.beginning_of_day, day.end_of_day)
  end

  def next_slot_available
    time = "Not Available"
    slots.each do |slot|
      if slot.available? && slot.slot_time > Time.now
        time = in_ist(slot.slot_time).strftime("%I:%M %p %b %d")
        break
      end
    end
    time
  end
end
