class CreateActivities < ActiveRecord::Migration
  @@tables = [:issues, :attachments, :changesets, :documents, :journals, :messages, :news, :wiki_contents, :wiki_content_versions, :versions]
  
  def self.up
    @@tables.each do |table|
      add_column table, :activity_created_at, :datetime
      add_column table, :activity_created_by_id, :integer
      add_column table, :activity_updated_at, :datetime
      add_column table, :activity_updated_by_id, :integer
    end
  end

  def self.down
    @@tables.each do |table|
      remove_column table, :activity_created_at
      remove_column table, :activity_created_by_id
      remove_column table, :activity_updated_at
      remove_column table, :activity_updated_by_id
    end
  end
end
