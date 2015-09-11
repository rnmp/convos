class Topic < ActiveRecord::Base
	has_many :convos
	validates :name, presence: true
end
