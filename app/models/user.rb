class User < ActiveRecord::Base
  # attr_accessible :name, :email, :remember_token
  has_many :charts, dependent: :destroy
  has_many :dashboards, dependent: :destroy
  has_many :tables, dependent: :destroy
  before_create :create_remember_token

  def self.from_omniauth(auth)
    if user = where(auth.slice(:provider, :uid)).first
      user.update_attributes({name: auth[:info][:name], email: auth[:info][:email]})
      user
    else
      create_from_omniauth(auth)
    end
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth[:provider]
      user.uid = auth[:uid]
      user.name = auth[:info][:name]
      user.email = auth[:info][:email]
    end
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
