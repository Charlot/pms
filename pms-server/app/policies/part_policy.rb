class PartPolicy < ApplicationPolicy
  def update?
    user.has_role? :admin
  end

  def show?
    true
  end

  def destroy?
    user.has_role? :av
  end

  def new?
    user.has_role? :av
  end

  def edit?
    user.has_role? :av
  end

  def update?
    user.has_role? :av
  end
end