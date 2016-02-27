class AddEditedToConvo < ActiveRecord::Migration
  def up
    add_column :convos, :edited, :boolean, default: false
  end
  def down
    remove_column :convos, :edited
  end
end
