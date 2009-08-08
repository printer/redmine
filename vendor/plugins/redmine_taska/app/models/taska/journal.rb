module Taska
  module Journal
    def self.included(base)
      base.class_eval do
        self.activity_provider_options['issues'][:find_options][:conditions] = 
          "#{::Journal.table_name}.journalized_type = 'Issue' AND #{::Journal.table_name}.notes <> ''"
      end
    end
    
    def event_title
      "Re: ##{issue.id}, #{issue.subject}"
    end
    
    def activity_action
      activity_created_at == activity_updated_at ? 'posted' : 'updated'
    end
  end
end