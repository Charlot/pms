module Users
  class SessionPolicy<ApplicationPolicy
    def destroy?
      true
    end

    def new?
      true
    end

    def create?
      true
    end
  end
end