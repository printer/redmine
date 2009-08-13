require 'ftools'

module Taska
  module Attachment
    def self.included(base)
      base.class_eval do
        belongs_to :project
        
        alias_method_chain :before_save, :taska
      end
    end
    
    def before_save_with_taska
      before_save_without_taska
      
      if container.is_a?(Project)
        self.project = container
      else
        self.project = container.project if container.respond_to?(:project)
      end
    end
    
    def after_save
      File.syscopy(diskfile, thumb) if image?
    end
    
    def thumb_uri
      "thumbs/#{id}.jpg"
    end
    
    def thumb
      "#{RAILS_ROOT}/public/images/" + thumb_uri
    end
     
    def activity_action
      'uploaded'
    end
  end
end