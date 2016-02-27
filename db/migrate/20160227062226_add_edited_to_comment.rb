class AddEditedToComment < ActiveRecord::Migration
  def up
    add_column :comments, :edited, :boolean, default: false
  end
  def down
    remove_columnt :comments, :edited
  end
end
