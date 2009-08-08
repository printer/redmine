module Redmine
  module Activity
    module FetcherPatch
      def self.included(base)
        base.class_eval do
          alias_method_chain :events, :taska
        end
      end
      
      def events_with_taska(from = nil, to = nil, options={})
        e = []
        @options[:limit] = options[:limit]
        
        @scope.each do |event_type|
          constantized_providers(event_type).each do |provider|
            e += provider.find_events(event_type, @user, from, to, @options)
          end
        end
        
        if options[:limit]
          e = e.sort_by{|a| a.activity_updated_at}.reverse
          e = e.slice(0, options[:limit])
        end
        e
      end
    end
  end
end