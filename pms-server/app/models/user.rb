class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:user_name]

  validates :user_name, presence: true, uniqueness: {message: '登陆名必须唯一'}

  scoped_search on: :name

  attr_accessor :jack

  def ensure_autnehtication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def email_required?
    false
  end

  # def role=
  #   raise
  # end

  def role
    r=roles.first
    return r.nil? ? nil : r.name
  end

  def role_name
    roles.collect { |role| role.name }
  end

  def av?
    has_role? :av
  end

  def admin?
    has_role? :admin
  end

  def cutting?
    has_role? :cutting
  end

  def system?
    has_role? :system
  end


  def can_modify_data?
    av? || admin? || system?
  end

  def can_delete_data?
    admin? || system?
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
