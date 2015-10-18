module VoteActions
  def upvote(user)
    user.vote_for(self)
    cache_points
    self.update_popularity
  end
  def downvote(user)
    user.vote_against(self)
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
