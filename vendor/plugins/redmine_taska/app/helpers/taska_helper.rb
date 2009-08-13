module TaskaHelper
  def project_abbr(project)
    result = ""
    
    project.split.each do |word|
      result += word.first
    end
    
    result
  end
  
  def link_to_taska_attachments(container, options = {})
    options.assert_valid_keys(:author, :manage, :find_conditions)
    
    if container.attachments.any?
      options = {:deletable => container.attachments_deletable?, :author => true}.merge(options)
      render :partial => 'attachments/links', :locals => {:attachments => container.attachments.find(:all, :conditions => options[:find_conditions]), :options => options}
    end
  end
end