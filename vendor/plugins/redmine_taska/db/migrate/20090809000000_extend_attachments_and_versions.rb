class ExtendAttachmentsAndVersions < ActiveRecord::Migration
  def self.up
    add_column :attachments, :project_id, :integer
    
    Attachment.all.each do |a|
      if a.container.is_a?(Project)
        a.update_attribute(:project_id, a.container.id)
      else
        a.update_attribute(:project_id, a.container.project.id) if a.container.respond_to?(:project)
      end
    end
    
    add_column :versions, :closed, :bool, :default => false
  end

  def self.down
    remove_column :attachments, :project_id
    remove_column :versions, :closed
  end
end
