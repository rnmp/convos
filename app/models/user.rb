class User < ActiveRecord::Base
  has_many :convos, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  validates :email, :password_digest, presence: true, unless: :guest?
  validates :email, uniqueness: true, unless: :guest?
  validates :password, confirmation: true
  has_secure_password(validations: false)
  acts_as_voter

  def self.new_guest
    new { |u| u.guest = true }
  end

  def total_points
    total_points = 0
    self.convos.each do |convo|
      total_points += convo.points
    end
    self.comments.each do |comment|
      total_points += comment.points
    end
    total_points
  end

  def can_post_new_convo?
    if self.convos.any?
      (Time.now - self.convos.last.created_at) > 1.minute
    else
      true
    end
  end

  def can_edit?(convo_or_comment)
    convo_or_comment.user == self || self.admin?
  end
end
