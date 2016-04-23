class Poll < ActiveRecord::Base
  belongs_to :user
  has_many :options, foreign_key: "poll_id", class_name: "PollOption"

  def votes
    votes = 0
    options.each { |option| votes += option.votes_for }
    votes
  end

  def self.create_with_options(poll_options)
    poll = Poll.create
    poll_options.each do |name|
      PollOption.create(name: name, poll_id: poll.id)
    end
    poll
  end
end
