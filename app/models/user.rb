class User < ActiveRecord::Base
  has_many :convos
  has_many :comments
  validates :email, :password_digest, presence: true, unless: :guest?
  validates :password, confirmation: true
  has_secure_password(validations: false)
  acts_as_voter

  VOTE_LIMIT = 10

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

  def vote_count_for(voteable)
    Vote.where(voter_id: self.id, voteable_id: voteable.id, voteable_type: voteable.class.to_s).count
  end

  def remainder_votes_for(voteable)
    VOTE_LIMIT - vote_count_for(voteable)
  end

  def can_vote_on?(voteable)
    vote_count_for(voteable) < VOTE_LIMIT
  end
end
