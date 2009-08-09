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
  end
  
  def list_files_with_taska
    sort_init 'filename', 'asc'
    sort_update 'filename' => "#{Attachment.table_name}.filename",
                'created_on' => "#{Attachment.table_name}.created_on",
                'size' => "#{Attachment.table_name}.filesize",
                'downloads' => "#{Attachment.table_name}.downloads"
    
    @filter = params[:filter]

    if @filter == 'documents'
      conditions = {:project_id => @project.id, :container_type => 'Document'}
    else
      conditions = {:project_id => @project.id}
      @filter = nil
    end

    @files = Attachment.find(:all, :conditions => conditions, :order => sort_clause)
    @files = @files.group_by{|f| f.created_on.to_date}
    
    # sort_init 'filename', 'asc'
    # sort_update 'filename' => "#{Attachment.table_name}.filename",
    #             'created_on' => "#{Attachment.table_name}.created_on",
    #             'size' => "#{Attachment.table_name}.filesize",
    #             'downloads' => "#{Attachment.table_name}.downloads"
    #             
    # @containers = [ Project.find(@project.id, :include => :attachments, :order => sort_clause)]
    # @containers += @project.versions.find(:all, :include => :attachments, :order => sort_clause).sort.reverse
    render :layout => !request.xhr?
  end
  
  alias_method_chain :add_version, :taska
  alias_method_chain :show, :taska
  alias_method_chain :list_files, :taska
end