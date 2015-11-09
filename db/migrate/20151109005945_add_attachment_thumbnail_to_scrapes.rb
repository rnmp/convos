class AddAttachmentThumbnailToScrapes < ActiveRecord::Migration
  def self.up
    change_table :scrapes do |t|
      t.attachment :thumbnail
    end
  end

  def self.down
    remove_attachment :scrapes, :thumbnail
  end
end
