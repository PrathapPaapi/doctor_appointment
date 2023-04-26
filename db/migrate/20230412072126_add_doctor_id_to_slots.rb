class AddDoctorIdToSlots < ActiveRecord::Migration[7.0]
  def change
    add_column :slots, :doctor_id, :integer
  end
end
