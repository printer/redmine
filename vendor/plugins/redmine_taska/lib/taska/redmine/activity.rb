require 'redmine/activity'

module Redmine
  module Activity
    def self.clear
      @@providers = Hash.new {|h,k| h[k]=[] }
      @@available_event_types = []
      @@default_event_types = []
    end
  end
end