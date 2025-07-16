class User < ApplicationRecord
  has_one :student

  has_secure_password

  # validations
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
end
