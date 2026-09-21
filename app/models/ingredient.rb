class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :unit, presence: true, length: { maximum: 30 }
end
