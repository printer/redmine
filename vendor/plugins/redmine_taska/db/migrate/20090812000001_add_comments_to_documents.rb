class AddCommentsToDocuments < ActiveRecord::Migration
  class Permission < ActiveRecord::Base; end
  
  def self.up
    add_column :documents, :comments_count, :integer
    
    add_column :comments, :activity_created_at, :datetime
    add_column :comments, :activity_created_by_id, :integer
    add_column :comments, :activity_updated_at, :datetime
    add_column :comments, :activity_updated_by_id, :integer
    
    add_index :comments, :activity_updated_at
    
    add_column :attachments, :current_version, :integer
  end

  def self.down
    remove_column :documents, :comments_count
    
    remove_column :comments, :activity_created_at
    remove_column :comments, :activity_created_by_id
    remove_column :comments, :activity_updated_at
    remove_column :comments, :activity_updated_by_id
    
    remove_column :attachments, :current_version
  end
end
