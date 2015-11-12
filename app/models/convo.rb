class Convo < ActiveRecord::Base
  belongs_to :topic
  belongs_to :scrape
  has_many :comments

  validates :title, presence: true

  before_validation :smart_add_url_protocol
  validates :url, url:true, presence: true, unless: ->(convo){convo.comment.present?}

  before_validation :create_slug
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  validates :comment, absence: true, if: ->(convo){convo.url.present?}
  
  acts_as_voteable
  include VoteActions

  before_save :create_scrape

  def self.search(search)
    if search
      where("title LIKE ? OR comment LIKE ?", "%#{search}%", "%#{search}%")
    else
      all
    end
  end

  def to_param
    slug
  end

  protected

  def smart_add_url_protocol
    unless self.comment.present?
      unless self.url[/^http:\/\//] || self.url[/^https:\/\//]
        self.url = "http://#{self.url}"
      end
    end
  end

  $our_epoch = Time.local(2005, 12, 8, 7, 46, 43).to_time

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

    result = (displacement * sign.to_f) + ( epoch_seconds(created_at) / 45000 )
    self.update_attribute(:weighted_score, result)
  end

  def create_scrape
    if self.url.present?
        @scrape = Scrape.new(url: self.url)
        if @scrape.save
          self.scrape_id = @scrape.id
        end
      end
  end

  private

  def create_slug
    self.slug = name.parameterize
  end

end
