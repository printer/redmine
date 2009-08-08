module TaskaHelper
  def project_abbr(project)
    result = ""
    
    project.split.each do |word|
      result += word.first
    end
    
    result
  end
end