class Slot < ApplicationRecord
  belongs_to :doctor
  # validates :currency, presence: true
end
