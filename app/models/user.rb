class User < ApplicationRecord
  # has_many :slots, dependent: :destroy
  # validates :name, :email, presence: true
  validates :name, length: { minimum: 3 }
  validates :name, format: { with: /\A[^0-9`!@#\$%\^&*+_=]+\z/}
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: ":Enter a valid mail-id" }
  validates :currency, presence: true
end
