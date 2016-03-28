module VoteActions
  def upvote(user)
    if user.voted_on?(self)
      user.unvote_for(self)
    else
      user.vote_for(self)
    end
    cache_points
    self.update_popularity
  end

  def downvote(user)
    if user.voted_on?(self)
      user.unvote_for(self)
    else
      user.vote_against(self)
    end
    cache_points
    self.update_popularity
  end

  protected

  def cache_points
    self.update_attribute(:points, self.plusminus)
    self.update_attribute(:upvotes, self.votes_for)
    self.update_attribute(:downvotes, self.votes_against)
  end
end
