class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :doctor_name
      t.text :address
      t.string :image_url
      t.text :slots, array: true, default: []

      t.timestamps
    end
  end
end
