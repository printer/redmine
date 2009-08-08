class Activity < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :event, :polymorphic => true
  
  def url
    name = (event_type + "_url").to_sym
    
    if respond_to? name
      send name
    end
  end
  
  def issue_url
    {:controller => 'issues', :action => 'show', :id => foreign_id}
  end
  
  def document_url
    {:controller => 'documents', :action => 'show', :id => foreign_id}
  end
  
  def wiki_url
    {:controller => 'wiki', :action => 'index', :id => project.identifier, :page => foreign_id}
  end
end