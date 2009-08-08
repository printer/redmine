require 'redmine/i18n'

module Redmine
  module I18n
    def abbr_day_name(day)
      ::I18n.t('date.abbr_day_names')[day % 7]
    end
  end
end