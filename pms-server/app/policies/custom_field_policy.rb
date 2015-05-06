class CustomFieldPolicy<ApplicationPolicy
  def validate?

    # update?
    #user.has_role? :admin
    true
  end
end