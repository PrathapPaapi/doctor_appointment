class Doctor < ApplicationRecord
  has_many :slots, dependent: :destroy
end
