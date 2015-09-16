class AddPointsToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :points, :integer, default: 0
  end
end
