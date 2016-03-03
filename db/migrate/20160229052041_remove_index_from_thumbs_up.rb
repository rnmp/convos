class RemoveIndexFromThumbsUp < ActiveRecord::Migration
  def change
    remove_index :votes, name: 'fk_one_vote_per_user_per_entity'
  end
end
