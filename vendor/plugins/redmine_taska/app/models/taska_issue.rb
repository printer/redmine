module TaskaIssue
  def self.included(base)
    base.class_eval do
      alias_method_chain :event_title, :taska
    end
  end
  
  def event_title_with_taska
    "##{id}: #{subject}"
  end
  
  def event_activity_type
    l(:label_issue)
  end
end