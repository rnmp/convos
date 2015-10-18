class Comment < ActiveRecord::Base
  belongs_to :convo

  validates :comment, presence: true

  acts_as_tree

  acts_as_voteable
  include VoteActions

  after_create :update_popularity

  def self.search(search)
    if search
      where("comment LIKE ?", "%#{search}%")
    else
      all
    end
  end

  protected
  
  def update_popularity
    if points == 0
        return 0
    end
    z = 1.96
    phat = 1.0*upvotes/points
    result = (phat + z*z/(2*points) - z * Math.sqrt((phat*(1-phat)+z*z/(4*points))/points))/(1+z*z/points)
    self.update_attribute(:weighted_score, result)
  end
end
