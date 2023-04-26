class RemoveSlotsFromDoctors < ActiveRecord::Migration[7.0]
  def change
    remove_column :doctors, :slots, :text
  end
end
