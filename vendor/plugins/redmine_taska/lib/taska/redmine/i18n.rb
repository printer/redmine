require 'redmine/i18n'

module Redmine
  module I18n
    def abbr_day_name(day)
      ::I18n.t('date.abbr_day_names')[day % 7]
    end
    
    def format_short_time(time, include_date = true)
      return nil unless time
      
      zone = User.current.time_zone
      local = zone ? time.in_time_zone(zone) : (time.utc? ? time.localtime : time)
      
      include_date ? local.strftime('%d/%m/%y %H:%M:%S') : local.strftime('%H:%M:%S')
    end
  end
end