class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates :name, :amount, :unit, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 1 }
end
