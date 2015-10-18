class AddWeightedScoreToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :weighted_score, :float, default: 0
  end
end
