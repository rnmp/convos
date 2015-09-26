class CreateScrapes < ActiveRecord::Migration
  def change
    create_table :scrapes do |t|
      t.string :url
      t.string :title
      t.text :description
      t.text :images

      t.timestamps null: false
    end
  end
end
