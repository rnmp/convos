class AddSlugToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :slug, :string
    add_index :convos, :slug, unique: true
  end
end
