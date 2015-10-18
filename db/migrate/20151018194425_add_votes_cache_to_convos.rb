class AddVotesCacheToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :upvotes, :integer, default: 0
    add_column :convos, :downvotes, :integer, default: 0
  end
end
