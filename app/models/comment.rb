class Comment < ActiveRecord::Base
  belongs_to :convo
  belongs_to :user

  validates :user, presence: true
  validates :comment, presence: true

  acts_as_tree

  acts_as_voteable
  include VoteActions
  include Report

  def self.search(search)
    if search
      where("comment LIKE ?", "%#{search}%")
    else
      all
    end
  end

  def update_popularity
    if points == 0
        return 0
    end
    z = 1.281551565545 # 80% confidence
    n = upvotes + downvotes
    phat = 1.0*upvotes/n
    result = (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)

    self.update_attribute(:weighted_score, result)
  end
end
