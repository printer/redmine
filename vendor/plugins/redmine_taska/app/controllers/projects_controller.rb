require_dependency 'projects_controller'

class ProjectsController < ApplicationController
  unloadable
  
  menu_item :roadmap, :only => :add_version
  
  def add_version_with_taska
  	@version = @project.versions.build(params[:version])
  	if request.post? and @version.save
  	  flash[:notice] = l(:notice_successful_create)
      redirect_to :controller => 'projects', :action => 'roadmap', :id => @project
  	end
  end
  
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
    @events   = @activity.events(nil, nil, :limit => 50).group_by{|e| e.activity_updated_at.to_date}
    
    @late = Version.find_late
  end
  
  def list_files_with_taska
    @category = params[:category]

    conditions = {:project_id => @project.id}

    if @category == 'documents'
      conditions.merge!({:container_type => 'Document'})
    elsif @category == 'wiki'
      conditions.merge!({:container_type => 'WikiPage'})
    else
      @category = nil
    end

    @files    = Attachment.find(:all, :conditions => conditions, :order => 'created_on DESC')
    @versions = @files.select{|f| !f.current_version.blank?}.group_by{|f| f.current_version}
    
    @files = @files.select{|f| f.current_version.blank?}
    
    @sort_by = params[:sort_by]
    
    if @sort_by == 'title'
      @files = @files.sort_by(&:filename).group_by{|f| f.filename.first}
    elsif @sort_by == 'size'
      @files = @files.sort_by(&:filesize).group_by{|f| f.filesize > 1000000 ? '> 1 Mb' : '< 1 Mb'}
    else
      @files = @files.group_by{|f| f.created_on.to_date}
      @sort_by = nil
    end
    
    render :layout => !request.xhr?
  end
  
  alias_method_chain :add_version, :taska
  alias_method_chain :show, :taska
  alias_method_chain :list_files, :taska
end