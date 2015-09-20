class Comment < ActiveRecord::Base
  belongs_to :convo
  validates :comment, presence: true
  acts_as_tree
  acts_as_voteable

  def self.search(search)
    if search
      where("comment LIKE ?", "%#{search}%")
    else
      all
    end
  end
end
