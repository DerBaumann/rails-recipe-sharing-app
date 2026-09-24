class CommentPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    user.present? && (record.author == user || user.admin?)
  end
end
