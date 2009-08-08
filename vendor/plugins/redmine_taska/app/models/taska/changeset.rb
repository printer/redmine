module Taska
  module Changeset
    def event_title
      "##{repository.scm_name == 'Git' ? revision.first(5) : revision}" + (short_comments.blank? ? '' : (', ' + short_comments))
    end
    
    def activity_action
      "posted"
    end
  end
end