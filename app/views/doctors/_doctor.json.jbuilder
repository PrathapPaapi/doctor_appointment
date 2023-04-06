json.extract! doctor, :id, :doctor_name, :address, :image_url, :slots, :created_at, :updated_at
json.url doctor_url(doctor, format: :json)
