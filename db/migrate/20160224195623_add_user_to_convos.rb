class AddUserToConvos < ActiveRecord::Migration
  def change
    add_reference :convos, :user, index: true, foreign_key: true
  end
end
