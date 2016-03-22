class User < ActiveRecord::Base
  has_many :convos
  has_many :comments
  has_many :notifications
  validates :email, :password_digest, presence: true, unless: :guest?
  validates :password, confirmation: true
  has_secure_password(validations: false)
  acts_as_voter

  def self.new_guest
    new { |u| u.guest = true }
  end

  def last_convo
    self.convos.last
  end

  def can_post_new_convo?
    if self.convos.count >= 1
      (Time.now - last_convo.created_at) > 1.minute
    else
      true
    end
  end
end
