class RecipePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.is_published? || (user.present? && (record.user == user || user.admin?))
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (record.user == user || user.admin?)
  end

  def destroy?
    user.present? && (record.user == user || user.admin?)
  end

  # Scope steuert, welche Rezepte in einer Liste auftauchen
  class Scope < Scope
    def resolve
      if user&.admin?
        # Admins sehen alle Rezepte (auch fremde Entwürfe)
        scope.all
      elsif user.present?
        # Eingeloggte User sehen veröffentlichte Rezepte + ihre eigenen Entwürfe
        scope.published.or(scope.where(user: user))
      else
        # Gäste sehen nur veröffentlichte Rezepte
        scope.published
      end
    end
  end
end
