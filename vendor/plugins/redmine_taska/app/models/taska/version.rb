module Taska
  module Version
    def self.included(base)
      base.class_eval do
        acts_as_event :title => Proc.new {|o| o.name},
                      :author => Proc.new {|o| o.activity_created_by_id},
                      :datetime => :updated_on,
                      :type => 'version',
                      :url => Proc.new {|o| {:controller => 'versions', :action => 'show', :id => o.id}}
        
        acts_as_activity_provider :type => 'versions',
                                  :timestamp => "#{table_name}.updated_on",
                                  :author_key => 'activity_created_by_id',
                                  :find_options => {:include => :project}
      end
    end
  end
end