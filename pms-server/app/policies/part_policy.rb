class PartPolicy < ApplicationPolicy
  def update?
    #user.has_role? :admin
    user.av?
  end
end