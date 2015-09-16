class Comment < ActiveRecord::Base
	belongs_to :convo
	validates :comment, presence: true
	acts_as_tree
	acts_as_voteable
end
