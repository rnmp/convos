module VoteActions
  def upvote(user)
    user.vote_for(self)
    update_points
  end
  def downvote(user)
    user.vote_against(self)
    update_points
  end

  protected

  def update_points #cache
    self.update_attribute(:points, self.plusminus)
  end
end
