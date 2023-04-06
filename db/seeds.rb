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
  doctor_name: 'Eren',
  address: 'Koramangala',
  image_url: "eren.jpeg"
  )

Doctor.create!(
  doctor_name: 'Goku',
  address: 'JP Nagar',
  image_url: 'goku.webp'
  )

Doctor.create!(
  doctor_name: 'Ichigo',
  address: 'Indiranagar',
  image_url: 'ichigo.jpeg'
  )

Doctor.create!(
  doctor_name: 'Naruto',
  address: 'Whitefield',
  image_url: 'eren.jpeg'
  )

Doctor.create!(
  doctor_name: 'Orihime',
  address: 'Rajajinagar',
  image_url: 'orihime.webp'
  )

Doctor.create!(
  doctor_name: 'Violet',
  address: 'Heaven',
  image_url: 'violet.png'
  )