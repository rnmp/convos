class AddConvoToConvo < ActiveRecord::Migration
  def change
    add_column :convos, :convo, :text
  end
  def data
    convos = Convo.all
    convos.each do |convo|
      if convo.url != ""
        convo.convo = "# [#{convo.title}](#{convo.url})"
      else
        convo.convo = "# #{convo.title} \n#{convo.comment}"
      end
      convo.save
    end
  end
end
