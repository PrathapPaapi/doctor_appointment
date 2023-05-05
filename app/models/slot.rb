class Slot < ApplicationRecord
  belongs_to :doctor
  def update_currency_and_user_id(params, user_id)
    assign_attributes(
      available: false,
      currency: params[:currency],
      currency_rate: CurrencyConversionRate.get_currency_rate(params[:currency]),
      user_id: user_id)
    save
  end

  def update_cancelled_slot
    assign_attributes(user_id: nil, currency: nil, currency_rate: nil, available: true)
    save
  end
end
