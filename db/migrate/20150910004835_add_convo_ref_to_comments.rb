class AddConvoRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :convo, index: true, foreign_key: true
  end
end
