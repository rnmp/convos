class RemoveUrlAuthorAndCommentFromConvo < ActiveRecord::Migration
  def change
    remove_column :convos, :title
    remove_column :convos, :url
    remove_column :convos, :comment
  end
end
