class Convo < ActiveRecord::Base
  extend FriendlyId
  friendly_id :convo, use: [:slugged, :finders]

  belongs_to :topic
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :convo, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  acts_as_voteable
  include VoteActions

  include ApplicationHelper

  def normalize_friendly_id(string)
    super[0..40]
  end

  def title
    # matches first HTML tag and uses it's content as title
    # e.g. if convo.convo is `<p>Hello</p><p>How are you?</p>`
    # `convo.title` would result in `Hello`
    # TODO: use for convo.slug
    # TODO: what if convo starts with image/multimedia? (use `alt`?)
    /<.*>/.match(markdown(convo))[0].gsub!(/<[^>]*>/, '').html_safe.truncate(70)
  end

  def self.search(search)
    if search
      where("title LIKE ? OR comment LIKE ?", "%#{search}%", "%#{search}%")
    else
      all
    end
  end

  $our_epoch = Time.local(2015, 1, 1, 1, 1, 1).to_time

  def epoch_seconds(t)
    (t.to_i - $our_epoch.to_i).to_f
  end

  def update_popularity
    s = points
    displacement = Math.log( [s.abs, 1].max,  10 )

    sign = if s > 0
      1
    elsif s < 0
      -1
    else
      0
    end

    result = (displacement * sign.to_f * 10) + ( epoch_seconds(created_at) / 45000 )
    self.update_attribute(:weighted_score, result)
  end

end
