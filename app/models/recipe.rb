class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  belongs_to :user
  has_many :favourites, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank

  validates :title, :instructions, presence: true
  validates :prep_time_minutes, numericality: { greater_than_or_equal_to: 0 }

  def owned_by?(user)
    user.present? && self.user == user
  end

  def favourited_by?(user)
    return false unless user
    favourites.exists?(user_id: user.id)
  end

  def average_rating
    return 0.0 if comments.empty?
    comments.average(:rating).round(1)
  end

  scope :published, -> { where(is_published: true) }

  scope :search_by_title, ->(query) {
    where("LOWER(title) LIKE ?", "%#{query.downcase}%") if query.present?
  }
end
