class User < ActiveRecord::Base
  attr_accessor :reset_token, :current_password

  has_many :convos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :polls, dependent: :destroy
  has_many :notifications, dependent: :destroy

  acts_as_voter

  has_secure_password validations: false

  validates :email, presence: true, unless: :guest?
  validates :email, uniqueness: true, unless: lambda { |user| user.email.blank? }
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, unless: :guest?

  validates :password_digest, presence: true, unless: :guest?
  validates :password, length: { minimum: 6}, on: :create, unless: :guest?
  validates :password, length: { minimum: 6}, on: :update, unless: lambda { |user| user.password.blank? }


  def self.new_guest
    new { |u| u.guest = true }
  end

  def self.admins
    where(admin: true)
  end

  def self.test_users
    where("email ~ ?", '^testuser\d*@convos.org$')
  end

  def is_test_user?
    email =~ /^testuser\d*@convos.org$/
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

  def transfer_items_to(user)
    convos.update_all(user_id: user.id)
    comments.update_all(user_id: user.id)
    notifications.update_all(user_id: user.id)
    votes.update_all(voter_id: user.id)
  end

  def can_post_new_convo?
    if self.convos.any?
      (Time.now - self.convos.last.created_at) > 1.minute
    else
      true
    end
  end

  def can_vote_in_poll?(poll)
    poll.options.each do |option|
      if self.voted_on?(option)
        return false
      end
    end
  end

  def can_edit?(convo_or_comment)
    convo_or_comment.user == self # || self.admin?
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

end
