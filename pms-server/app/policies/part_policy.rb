class PartPolicy
  attr_reader :user, :part

  def initialize(user,post)
    @user = user
    @post = post
  end

  def update?
    user.has_role? :admin
  end
end