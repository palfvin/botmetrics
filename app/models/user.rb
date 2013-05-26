class User < ActiveRecord::Base
  attr_accessible :name, :email
  has_many :charts, dependent: :destroy
  has_many :dashboards, dependent: :destroy

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

end
