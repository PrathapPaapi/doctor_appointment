class Slot < ApplicationRecord
  belongs_to :doctor
  def self.update_currency_and_user_id(params, user_id)
    slot = Slot.find(params[:slot_id])
    slot.available = false
    slot.currency = params[:currency]
    slot.currency_rate = CurrencyConversionRate.get_currency_rate(params[:currency])
    slot.user_id = user_id
    slot.save
  end

  def self.update_cancelled_slot(slot_id)
    slot = Slot.find(slot_id)
    slot.user_id = nil
    slot.currency = nil
    slot.currency_rate = nil
    slot.available = true
    slot.save
  end
end
