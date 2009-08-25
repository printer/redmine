require_dependency 'attachments_controller'

class AttachmentsController < ApplicationController
  unloadable
  
  before_filter :authorize, :only => :new_version
  
  def list_images
    @attachment.inspect
    @container = @attachment.container
    
    render :layout => false
  end
  
  def new_version
    if request.post?
      container = @attachment.container
      currents  = Attachment.find(:all, :conditions => {:current_version => @attachment.id})
      currents << @attachment

      attachments = attach_files(container, params[:attachments])
      if !attachments.empty? && Setting.notified_events.include?('file_added')
        Mailer.deliver_attachments_added(attachments)
      end
      
      currents.each do |c|
        c.update_attribute(:current_version, attachments.first.id)
      end
      
      redirect_to :controller => 'projects', :action => 'list_files', :id => @project
      return
    end
  end
end