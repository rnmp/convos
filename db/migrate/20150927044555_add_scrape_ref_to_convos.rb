class AddScrapeRefToConvos < ActiveRecord::Migration
  def change
    add_reference :convos, :scrape, index: true, foreign_key: true
  end
end
