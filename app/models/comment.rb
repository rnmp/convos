class Comment < ActiveRecord::Base
	belongs_to :convo
	validates :comment, presence: true
	acts_as_tree order: 'created_at DESC'
end
