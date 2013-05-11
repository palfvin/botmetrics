class User < ActiveRecord::Base
  attr_accessible :name
  has_many :charts, dependent: :destroy
  has_many :dashboards, dependent: :destroy

  def self.from_omniauth(auth)
    where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = { 'developer' => auth['info']['name'] }[auth['provider']]
    end
  end

end
