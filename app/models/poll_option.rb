class PollOption < ActiveRecord::Base
  belongs_to :poll

  acts_as_voteable

  def percentage_of_votes
    self.votes_for.to_f / poll.votes.to_f * 100.00
  end

  def vote(user)
    user.vote_for(self) if user.can_vote_in_poll?(poll)
  end
end
