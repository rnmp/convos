class AddTopicRefToConvos < ActiveRecord::Migration
  def change
    add_reference :convos, :topic, index: true, foreign_key: true
  end
end
