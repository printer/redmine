module Taska
  module Document
    def self.included(base)
      base.class_eval do
        has_many :comments, :as => :commented, :dependent => :delete_all, :order => "created_on"
      end
    end
    
    def event_title
      title
    end
  end
end