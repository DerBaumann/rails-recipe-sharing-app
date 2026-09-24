class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :author, class_name: "User"

  validates :title, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, in: 1..5 }
  validates :author_id, uniqueness: { scope: :recipe_id, message: "hat dieses Rezept bereits bewertet." }
end
