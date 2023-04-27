class RemoveCurrencyCurrencyRateFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :currency, :string
    remove_column :users, :currency_rate, :decimal
  end
end
