class Convo < ActiveRecord::Base
	belongs_to :topic
	has_many :comments
	after_validation :smart_add_url_protocol
	validates :title, presence: true
	validates :url, presence: true, unless: ->(convo){convo.comment.present?}
	validates :comment, absence: true, if: ->(convo){convo.url.present?}
	acts_as_voteable

	def self.search(search)
	  if search
	    where("title LIKE ? OR comment LIKE ?", "%#{search}%", "%#{search}%")
	  else
	    all
	  end
	end

	protected

	def smart_add_url_protocol
		unless self.comment.present?
			unless self.url[/\Ahttp:\/\//] || self.url[/\Ahttps:\/\//]
				self.url = "http://#{self.url}"
			end
		end
	end
end
