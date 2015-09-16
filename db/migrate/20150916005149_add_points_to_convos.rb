class AddPointsToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :points, :integer
  end
end
