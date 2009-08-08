module Taska
  module Issue
    def self.included(base)
      base.class_eval do
        alias_method_chain :create_journal, :taska
      end
    end
  
    def create_journal_with_taska
      if @current_journal
        # attributes changes
        (::Issue.column_names - %w(id description lock_version created_on updated_on activity_updated_at)).each {|c|
          @current_journal.details << JournalDetail.new(:property => 'attr',
                                                        :prop_key => c,
                                                        :old_value => @issue_before_change.send(c),
                                                        :value => send(c)) unless send(c)==@issue_before_change.send(c)
        }
        #custom fields changes
        custom_values.each {|c|
          next if (@custom_values_before_change[c.custom_field_id]==c.value ||
                    (@custom_values_before_change[c.custom_field_id].blank? && c.value.blank?))
          @current_journal.details << JournalDetail.new(:property => 'cf', 
                                                        :prop_key => c.custom_field_id,
                                                        :old_value => @custom_values_before_change[c.custom_field_id],
                                                        :value => c.value)
        }      
        @current_journal.save
      end
    end
    
    def changed?
      c = changes
      c.delete('updated_on')
      c.any?
    end
    
    def event_title
      "##{id}, #{subject}"
    end
    
    def event_type
      'issue'
    end
    
    def activity_action
      closed? ? 'closed' : 'assigned'
    end
    
    def activity_author
      closed? ? activity_updated_by : assigned_to
    end
  end
end