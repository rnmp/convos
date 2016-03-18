class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :convos
  validates :name, presence: true
end
