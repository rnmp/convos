class Convo < ActiveRecord::Base
	belongs_to :topic
	has_many :comments
	validates :title, presence: true
	validates :url, presence: true, unless: ->(convo){convo.comment.present?}
	validates :comment, absence: true, if: ->(convo){convo.url.present?}
	acts_as_voteable
end
