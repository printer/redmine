
module Taska
  module Version
    def self.included(base)
      base.class_eval do
        belongs_to :responsible, :class_name => "User"
        
        acts_as_event :title => Proc.new {|o| o.name},
                      :author => Proc.new {|o| o.activity_created_by_id},
                      :datetime => :updated_on,
                      :type => 'version',
                      :url => Proc.new {|o| {:controller => 'versions', :action => 'show', :id => o.id}}
        
        acts_as_activity_provider :type => 'versions',
                                  :timestamp => "#{table_name}.updated_on",
                                  :author_key => 'activity_created_by_id',
                                  :find_options => {:include => :project}
       
        def self.find_late
          find(:all, :conditions => ["closed = ? AND effective_date < ?", 0, DateTime.now])
        end
                                  
        alias_method_chain :completed?, :taska
        alias_method_chain :activity_action, :closed
      end
    end
    
    def completed_with_taska?
      closed == "1"
    end
    
    def activity_action_with_closed
      completed? ? 'closed' : (activity_created_at == activity_updated_at ? 'created' : 'updated')
    end
  end
end