class CreateActivities < ActiveRecord::Migration
  @@tables = [:issues, :attachments, :changesets, :documents, :journals, :messages, :news, :wiki_contents, :wiki_content_versions, :versions]
  
  def self.up
    @@tables.each do |table|
      add_column table, :activity_created_at, :datetime
      add_column table, :activity_created_by_id, :integer
      add_column table, :activity_updated_at, :datetime
      add_column table, :activity_updated_by_id, :integer
      
      add_index table, :activity_updated_at
    end
    
    Issue.update_all 'activity_updated_at = created_on'
    Document.update_all 'activity_updated_at = created_on'
    Attachment.update_all 'activity_updated_at = created_on'
    Changeset.update_all 'activity_updated_at = committed_on'
    Journal.update_all 'activity_updated_at = created_on'
    News.update_all 'activity_updated_at = created_on'
    WikiContent.update_all 'activity_updated_at = updated_on'
    WikiContent::Version.update_all 'activity_updated_at = updated_on'
    Version.update_all 'activity_updated_at = created_on'
    Message.update_all 'activity_updated_at= created_on'
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
