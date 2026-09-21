class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy

  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank

  validates :title, :instructions, presence: true
  validates :prep_time_minutes, numericality: { greater_than_or_equal_to: 0 }
end
