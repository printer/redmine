require_dependency 'wiki_controller'

class WikiController < ApplicationController
  unloadable
  
  def index_with_taska
    page_title = params[:page]
    @page = @wiki.find_or_new_page(page_title)
    
    unless @page.content.nil?
      @versions = @page.content.versions.find :all, 
                                              :select => "id, author_id, comments, updated_on, version",
                                              :order => 'version DESC',
                                              :limit  =>  10
    else
      @versions = []
    end
                                            
    index_without_taska
  end
  
  def diff_with_taska
    if params[:version].is_a? Array
      params[:version_from] = params[:version][1]
      params[:version] = params[:version][0]
    end
    
    @diff = @page.diff(params[:version], params[:version_from])
    render_404 unless @diff
  end
  
  alias_method_chain :index, :taska
  alias_method_chain :diff, :taska
end