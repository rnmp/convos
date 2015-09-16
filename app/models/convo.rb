class Convo < ActiveRecord::Base
	belongs_to :topic
	has_many :comments
	before_validation :smart_add_url_protocol
	validates :title, presence: true
	validates :url, presence: true, unless: ->(convo){convo.comment.present?}
	validates :comment, absence: true, if: ->(convo){convo.url.present?}
	acts_as_voteable

	protected

	def smart_add_url_protocol
		unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
			self.url = "http://#{self.url}"
		end
	end
end
