module TaskaDocument 
  def self.included(base)
    base.class_eval do
      alias_method_chain :event_title, :taska
    end
  end
  
  def event_title_with_taska
    title
  end
  
  def event_activity_type
    l(:label_document)
  end
end