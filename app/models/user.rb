class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_recipes, through: :favourites, source: :recipe

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
end
