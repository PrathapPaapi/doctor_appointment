#---
# Excerpted from "Agile Web Development with Rails 7",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/rails7 for more book information.
#---
# encoding: utf-8
Doctor.delete_all
Doctor.create!(
  doctor_name: 'Eren Yeager',
  address: 'Koramangala',
  image_url: 'eren.jpeg'
  )

Doctor.create!(
  doctor_name: 'Son Goku',
  address: 'JP Nagar',
  image_url: 'goku.webp'
  )

Doctor.create!(
  doctor_name: 'Ichigo Kurosaki',
  address: 'Indiranagar',
  image_url: 'ichigo.jpeg'
  )

Doctor.create!(
  doctor_name: 'Naruto Uzumaki ',
  address: 'Whitefield',
  image_url: 'naruto.jpeg'
  )

Doctor.create!(
  doctor_name: 'Orihime Inoue',
  address: 'Rajajinagar',
  image_url: 'orihime.webp'
  )

Doctor.create!(
  doctor_name: 'Violet Evergarden',
  address: 'Heaven',
  image_url: 'violet.png'
  )

  doctors = Doctor.all

  doctors.each do |doctor|
    6.times do |s|
      first_period_start_time = Time.parse("12:00")
      first_period_end_time = Time.parse("13:00")
      second_period_start_time = Time.parse("14:00")
      second_period_end_time = Time.parse("16:00")
      for i in 0..23
        date = Time.parse("#{i}:00") + s.day
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