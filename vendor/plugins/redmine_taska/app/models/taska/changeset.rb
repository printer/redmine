module Taska
  module Changeset
    def event_title
      "##{revision}" + (short_comments.blank? ? '' : (', ' + short_comments))
    end
    
    def activity_action
      "posted"
    end
  end
end