class AddSlugToConvos < ActiveRecord::Migration
  def change
    add_column :convos, :slug, :string
  end
end
