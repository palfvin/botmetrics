class User < ActiveRecord::Base
  attr_accessible :name
  has_many :charts, dependent: :destroy
  has_many :dashboards, dependent: :destroy

  EMAIL_WHITELIST = ['palfvin@gmail.com', 'ealfvin@gmail.com', 'walfvin@gmail.com']

  def self.from_omniauth(auth)
    if user = where(auth.slice(:provider, :uid)).first
      user.name = auth[:info][:name]
      user.email = auth[:info][:email]
      user.save
      user
    else
      create_from_omniauth(auth) if EMAIL_WHITELIST.include(auth[:info][:email])
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

end
