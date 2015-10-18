class AddWeightedScoreToComments < ActiveRecord::Migration
  def change
    add_column :comments, :weighted_score, :float, default: 0
  end
end
