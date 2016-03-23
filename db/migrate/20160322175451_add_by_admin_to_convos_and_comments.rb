class AddByAdminToConvosAndComments < ActiveRecord::Migration
  def change
  	add_column :convos, :by_admin, :boolean, default: false
  	add_column :comments, :by_admin, :boolean, default: false
  	add_column :users, :admin, :boolean, default: false
  end
end
