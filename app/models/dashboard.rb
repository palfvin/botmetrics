class Dashboard < ActiveRecord::Base
  attr_accessible :chart_ids, :name, :description
  has_many :dashboard_elements, dependent: :destroy
  has_many :charts, through: :dashboard_elements
  belongs_to :user
  validates :user, presence: true
  validates :name, presence: true
end
