require_dependency 'versions_controller'

class VersionsController < ApplicationController
  unloadable

  def edit_with_taska
    if request.post? and @version.update_attributes(params[:version])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :controller => 'projects', :action => 'roadmap', :id => @project
    end
  end
  
  alias_method_chain :edit, :taska
end