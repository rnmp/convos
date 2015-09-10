class Convo < ActiveRecord::Base
	has_many :comments
	default_scope { order('votes DESC') }
end
