class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.text :message
      t.boolean :read

      t.timestamps null: false
    end
  end
end
