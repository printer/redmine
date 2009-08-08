require 'acts_as_activity_provider'

module Redmine
  module Acts
    module ActivityProvider
      module ClassMethods
        def acts_as_activity_provider_with_taska(options = {})
          acts_as_activity_provider_without_taska(options)
        end
        
        alias_method_chain :acts_as_activity_provider, :taska
      end
      
      module InstanceMethods    
        def self.included_with_taska(base)
          included_without_taska(base)

          base.class_eval do
            belongs_to :activity_created_by, :class_name => "User"
            belongs_to :activity_updated_by, :class_name => "User"
            
            before_create :touch_activity_created
            before_update :touch_activity_updated
          end
        end

        class << self
          alias_method_chain :included, :taska
        end

        def touch_activity_created
          self.activity_created_at = DateTime.now
          self.activity_created_by_id = User.current.id
          self.activity_updated_at = DateTime.now
          self.activity_updated_by_id = User.current.id
        end

        def touch_activity_updated
          self.activity_updated_at = DateTime.now if self.changed?
          self.activity_updated_by_id = User.current.id if self.changed?
        end
        
        def activity_action
          activity_created_at == activity_updated_at ? 'created' : 'updated'
        end

        def activity_author
          activity_created_at == activity_updated_at ? activity_created_by : activity_updated_by
        end
        
        module ClassMethods
          def find_events(event_type, user, from, to, options)
            provider_options = activity_provider_options[event_type]
            raise "#{self.name} can not provide #{event_type} events." if provider_options.nil?
            
            scope_options = {}
            cond = ARCondition.new
            if from && to
              cond.add(["#{provider_options[:timestamp]} BETWEEN ? AND ?", from, to])
            end
            if options[:author]
              return [] if provider_options[:author_key].nil?
              cond.add(["#{provider_options[:author_key]} = ?", options[:author].id])
            end
            cond.add(Project.allowed_to_condition(user, provider_options[:permission], options)) if provider_options[:permission]
            scope_options[:conditions] = cond.conditions

            if options[:limit]
              # id and creation time should be in same order in most cases
              scope_options[:order] = "#{table_name}.activity_updated_at DESC"
              scope_options[:limit] = options[:limit]
            end
            
            with_scope(:find => scope_options) do
              find(:all, provider_options[:find_options].dup)
            end
          end
        end
      end
    end
  end
end