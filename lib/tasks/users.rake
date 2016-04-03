namespace :users do
  desc "Destroy users with no activity (convos, comments, votes)"
  task purge_inactive: :environment do
    puts "Users destroyed:"
    users = User.all
    users.each do |user|
      if user.votes.count == 0 && user.convos.count == 0 && user.comments.count == 0
        # TODO: Use a query instead of check per user:
        # http://stackoverflow.com/questions/25813171/find-user-who-has-no-post-in-rails
        # Note: thought about using a class method User.inactive? but querying db is best
        # in the long run.
        puts "##{user.id}"
        user.destroy
      end
    end
  end
end
