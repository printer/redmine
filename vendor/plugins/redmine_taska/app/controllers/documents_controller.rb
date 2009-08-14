require_dependency 'documents_controller'

class DocumentsController < ApplicationController
  unloadable
  
  def index_with_taska
    @category = params[:category].to_i
    @category = nil if @category.blank? || @category == 0
    @category = DocumentCategory.find(@category) unless @category.nil?
    
    conditions = {}
    conditions[:category_id] = @category unless @category.nil?
    
    documents = @project.documents.find :all, :conditions => conditions, :include => [:attachments, :category], :order => 'created_on DESC'
    
    @grouped = documents.group_by{|d| d.created_on.to_date}.sort{|a,b| b[0] <=> a[0]}
    @document = @project.documents.build
    
    render :layout => false if request.xhr?
  end
  
  def show_with_taska
    @attachments = @document.attachments.find(:all, :conditions => {:current_version => nil}, :order => "created_on DESC")
    @comments = @document.comments
  end
  
  def edit_with_taska
    @categories = DocumentCategory.all
    if request.post? and @document.update_attributes(params[:document])
      attach_files(@document, params[:attachments])
      flash[:notice] = l(:notice_successful_update)
      redirect_to :action => 'show', :id => @document
    end
  end
  
  def add_comment
    @comment = Comment.new(params[:comment])
    @comment.author = User.current
    if @document.comments << @comment
      flash[:notice] = l(:label_comment_added)
      redirect_to :action => 'show', :id => @document
    else
      show
      render :action => 'show'
    end
  end
  
  alias_method_chain :index, :taska
  alias_method_chain :show, :taska
  alias_method_chain :edit, :taska
end