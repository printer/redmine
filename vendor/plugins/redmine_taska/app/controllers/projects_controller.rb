require_dependency 'projects_controller'

class ProjectsController < ApplicationController
  unloadable
  
#  helper :issues, :projects 
#  menu_item :state
  
  def show_with_taska
    if params[:jump]
      # try to redirect to the requested menu item
      redirect_to_project_menu_item(@project, params[:jump]) && return
    end
    
    @users_by_role = @project.users_by_role
    @subprojects = @project.children.visible
    
    cond = @project.project_condition(Setting.display_subprojects_issues?)
    
    TimeEntry.visible_by(User.current) do
      @total_hours = TimeEntry.sum(:hours, 
                                   :include => :project,
                                   :conditions => cond).to_f
    end
    @key = User.current.rss_key
    
    @calendar = Redmine::Helpers::Calendar.new(Date.today, current_language, :week)
    @calendar.expand 7.days

    @calendar.events = Version.find(:all, :include => :project,
                                    :conditions => ["(effective_date BETWEEN ? AND ?) AND project_id = ?", @calendar.startdt, @calendar.enddt, @project])
                                    
    @activity = Redmine::Activity::Fetcher.new(User.current, :project => @project)
    @events   = @activity.events(nil, nil, :limit => 5).group_by{|e| e.activity_updated_at.to_date}
  end
  
  alias_method_chain :show, :taska
end