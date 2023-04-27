class AddCurrencyCurrencyRateUserIdToSlots < ActiveRecord::Migration[7.0]
  def change
    add_column :slots, :currency, :string
    add_column :slots, :currency_rate, :decimal
    add_column :slots, :user_id, :integer
  end
end
