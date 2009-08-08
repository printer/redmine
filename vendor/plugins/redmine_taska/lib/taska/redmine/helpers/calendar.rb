require 'redmine/helpers/calendar'

module Redmine
  module Helpers
    class Calendar
      def expand(date)
        @enddt += date
      end
      
      def events
        @events
      end
    end
  end
end