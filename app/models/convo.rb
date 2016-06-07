class Convo < ActiveRecord::Base
  extend FriendlyId
  friendly_id :to_slug, use: [:slugged, :finders]

  belongs_to :topic
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :convo, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  before_save :handle_polls

  attr_accessor :img_url

  acts_as_voteable
  include VoteActions
  include Report
  include PollsHandler
  include ActionView::Helpers::SanitizeHelper

  def normalize_friendly_id(string)
    duplicates = Convo.where("slug like ?", "%#{super}%")
    if duplicates.any?
      super+"-#{('a'..'z').to_a[duplicates.count]}" 
    else
      super
    end
  end

  def to_slug
    @slug = title
    @slug.gsub!(/&\w*;/, '')
    @slug
  end

  def title
    # matches first HTML tag and uses its content as title
    # e.g. if convo.convo is `<p>Hello</p><p>How are you?</p>`
    # `convo.title` would result in `Hello`
    # TODO: what if convo starts with image/multimedia? (use `alt`?)
    
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    @title = strip_tags(markdown.render(convo.gsub(/\n.*$/, '')))

    if @title.blank?
      'untitled'
    else
      Redcarpet::Render::SmartyPants.render(@title).html_safe.truncate(70)
    end
  end

  def render
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    text = strip_tags(markdown.render(convo))
    Redcarpet::Render::SmartyPants.render(text).html_safe
  end


  def thumbnails
    # TODO: this may be replaced with a more fancy shit
    /https?:\/\/.*\.(png|gif|jpg|jpeg)/.match(convo).to_a
  end

  def commenters
    comments.map(&:user).uniq
  end

  def to_tweet
    render.truncate(thumbnails.any? ? 93 : 116) + (thumbnails.first if thumbnails.any?).to_s + " https://www.convos.org/topics/#{topic.slug}/#{id}/#{slug}"
  end

  def self.search(search)
    if search
      where("title LIKE ? OR comment LIKE ?", "%#{search}%", "%#{search}%")
    else
      all
    end
  end

  def handle_polls
    polls_handler(convo)
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
