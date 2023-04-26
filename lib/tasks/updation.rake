namespace :updation do
  desc "TODO"
  task slots_update: :environment do
    doctors = Doctor.all

    doctors.each do |doctor|
      first_period_start_time = Time.parse("12:00")
      first_period_end_time = Time.parse("13:00")
      second_period_start_time = Time.parse("14:00")
      second_period_end_time = Time.parse("16:00")
      for i in 0..23
        date = Time.parse("#{i}:00") + 6.day
        if ((date.hour >= first_period_start_time.hour && date.hour < first_period_end_time.hour) ||
          (date.hour >= second_period_start_time.hour && date.hour < second_period_end_time.hour))
          new_slot = doctor.slots.create!(
            slot_time: date,
            present: true,
            available: true
          )
        end
      end
    end
  end

end
