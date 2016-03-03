module VoteActions
  def upvote(user)
    if user.can_vote_on?(self)
      user.vote_for(self)
      cache_points
      self.update_popularity
    end
  end
  def downvote(user)
    if user.can_vote_on?(self)
      user.vote_against(self)
      cache_points
      self.update_popularity
    end
  end

  protected

  def cache_points
    self.update_attribute(:points, self.plusminus)
    self.update_attribute(:upvotes, self.votes_for)
    self.update_attribute(:downvotes, self.votes_against)
  end
end
