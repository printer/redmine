module AdditionalMenuHelper
  def render_additional_main_menu(project)
    render_menu((project && !project.new_record?) ? :project_right_menu : :application_right_menu, project)
  end
  
  def render_piped_menu(menu, project=nil)
    links = []
    menu_items_for(menu, project) do |item, caption, url, selected|
      links << content_tag('span', 
        link_to(h(caption), url))
    end
    links.empty? ? nil : links.join("<span class='pipe'>|</span>")
  end
end