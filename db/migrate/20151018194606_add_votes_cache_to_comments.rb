class AddVotesCacheToComments < ActiveRecord::Migration
  def change
    add_column :comments, :upvotes, :integer, default: 0
    add_column :comments, :downvotes, :integer, default: 0
  end
end
