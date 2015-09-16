class User < ActiveRecord::Base
	validates :email, :password_digest, presence: true, unless: :guest?
	validates :password, confirmation: true
	has_secure_password(validations: false)
	acts_as_voter

	def self.new_guest
		new { |u| u.guest = true }
	end
end
