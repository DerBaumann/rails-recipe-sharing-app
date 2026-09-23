class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank

  validates :title, :instructions, presence: true
  validates :prep_time_minutes, numericality: { greater_than_or_equal_to: 0 }

  def owned_by?(user)
    user.present? && self.user == user
  end

  scope :published, -> { where(is_published: true) }

  scope :search_by_title, ->(query) {
    where("LOWER(title) LIKE ?", "%#{query.downcase}%") if query.present?
  }
end
