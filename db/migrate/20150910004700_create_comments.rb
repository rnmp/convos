class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author
      t.integer :votes
      t.text :comment

      t.timestamps null: false
    end
  end
end
