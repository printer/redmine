module TaskaHelper
  def project_abbr(project)
    result = ""
    
    project.split.each do |word|
      result += word[0,1]
    end
    
    result
  end
end