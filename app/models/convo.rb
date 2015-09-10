class Convo < ActiveRecord::Base
	belongs_to :topic
	has_many :comments
	default_scope { order('votes DESC') }
end
