class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.datetime :slot_time
      t.boolean :present
      t.boolean :available

      t.timestamps
    end
  end
end
