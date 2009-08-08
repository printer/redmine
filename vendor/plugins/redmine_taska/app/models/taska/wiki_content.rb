module Taska
  module WikiContent
    def self.included(base)
      base.class_eval do
        acts_as_event :title => Proc.new {|o| "#{o.page.title} (#{l(:label_version)} #{o.version})"},
                      :description => :comments,
                      :datetime => :updated_on,
                      :type => 'wiki-page',
                      :url => Proc.new {|o| {:controller => 'wiki', :id => o.page.wiki.project_id, :page => o.page.title}}
        
        acts_as_activity_provider :type => 'wiki_edits',
                                  :timestamp => 'activity_updated_at',
                                  :author_key => 'author_id',
                                  :permission => :view_wiki_edits,
                                  :find_options => {:include => [:page, 
                                      {:page => [:wiki, 
                                        {:wiki => :project}
                                      ]}
                                    ]}
      end
    end
  end
end