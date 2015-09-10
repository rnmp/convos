class Comment < ActiveRecord::Base
	belongs_to :convo
	default_scope { order('votes DESC') }
end
