class Doctor < ApplicationRecord
  has_many :slots, dependent: :destroy

  def slots_for_day day
    slots.where("slot_time > ? AND slot_time < ?", day.beginning_of_day, day.end_of_day)
  end
end
