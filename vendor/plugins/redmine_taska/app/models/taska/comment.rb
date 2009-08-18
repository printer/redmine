module Taska
  module Comment
    def self.included(base)
      base.class_eval do
        acts_as_event :title => Proc.new {|o| o.commented_type == 'Document' ? "RE: #{o.commented.title}" : 'RE: ...'},
                      :description => :comments,
                      :datetime => :updated_on,
                      :type => 'comment',
                      :project => Proc.new {|o| o.commented.project},
                      :url => Proc.new {|o| {:controller => 'documents', :action => 'show', :id => o.commented_id, :anchor => "comment-#{o.id}"}}
        
        acts_as_activity_provider :type => 'comments',
                                  :timestamp => 'activity_updated_at',
                                  :author_key => 'author_id',
                                  :permission => :view_comments,
                                  :find_options => {
                                    :conditions => "commented_type = 'Document'",
                                    :joins => "LEFT JOIN #{::Document.table_name} ON #{::Document.table_name}.id = #{::Comment.table_name}.commented_id " +
                                              "LEFT JOIN #{::Project.table_name} ON #{::Project.table_name}.id = #{::Document.table_name}.project_id"
                                  }
      end
    end
    
    def project
      commented.project
    end
  end
end