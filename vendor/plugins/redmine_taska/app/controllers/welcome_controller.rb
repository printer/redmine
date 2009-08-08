require_dependency 'welcome_controller'

class WelcomeController < ApplicationController
  unloadable
  
  helper :issues, :projects
  
  menu_item :state
  
  def index_with_taska
    @projects = Project.all.sort
    
    @calendar = Redmine::Helpers::Calendar.new(Date.today, current_language, :week)
    @calendar.expand 7.days

    @calendar.events = Version.find(:all, :include => :project,
                                    :conditions => ["effective_date BETWEEN ? AND ?", @calendar.startdt, @calendar.enddt])

    @events = {}
    
    @projects.each do |p|
      @activity  = Redmine::Activity::Fetcher.new(User.current, :project => p)
      @events[p] ||= [] 
      @events[p] += @activity.events(nil, nil, :limit => 5)
    end
    
  end
  
  alias_method_chain :index, :taska
end