class CreateConvos < ActiveRecord::Migration
  def change
    create_table :convos do |t|
      t.string :title
      t.string :author
      t.integer :votes
      t.string :url
      t.text :comment

      t.timestamps null: false
    end
  end
end
