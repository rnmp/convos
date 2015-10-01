class RemoveVotesFromCommentsAndConvos < ActiveRecord::Migration
  def change
    remove_column :comments, :votes
    remove_column :convos, :votes
  end
end
