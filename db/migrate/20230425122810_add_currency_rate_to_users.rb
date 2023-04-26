class AddCurrencyRateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :currency_rate, :decimal
  end
end
