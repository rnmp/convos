module PollsHandler
  def polls_handler(content)
    polls = content.scan(/\(\) ?.*(?:\n\(\) ?.*)+/)
    if polls.any?
      polls.each do |poll|
        # create poll in db and associate with convo
        poll_options = []
        poll.scan(/\(\) ?(.*)/) do |item|
          poll_options.push(item[0])
        end
        @poll = Poll.create_with_options(poll_options)
        # replace this poll with new poll id in text with `(poll:{id})`
        content.gsub!(poll, "(poll:#{@poll.id})")
      end
    end
  end
end
