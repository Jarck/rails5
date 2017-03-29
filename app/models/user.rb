class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#,
         # :encryptable

  has_many :roles, :through => :users_roles
  has_many :topics
  has_many :pictures

  # 注册邮件提醒
  # after_create :send_welcome_mail
  # def send_welcome_mail
  #   UserMailer.welcome(id).deliver_later
  # end

  # 分配默认角色
  after_create :assign_default_role
  def assign_default_role
    self.add_role(:member) if self.roles.blank?
  end

  # 登录时可使用 用户名和邮箱
  def login=(login)
    @login = login
  end

  def login
    @login || self.name || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

end
