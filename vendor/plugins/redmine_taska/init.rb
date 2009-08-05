require 'redmine'
require 'dispatcher'

require 'patches/calendar'
require 'patches/i18n'

require 'taska_document'
require 'taska_issue'

Dispatcher.to_prepare do
  Issue.send(:include, TaskaIssue)
  Document.send(:include, TaskaDocument)
end

Redmine::Plugin.register :redmine_taska do
  name 'Redmine Taska plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end

ActionView::Base.send(:include, AdditionalMenuHelper)
ActionView::Base.send(:include, TaskaHelper)

Redmine::MenuManager.map :top_menu do |menu|
  menu.delete :projects
  menu.delete :administration
  menu.delete :help
  menu.delete :my_page
end

Redmine::MenuManager.map :project_menu do |menu|
  menu.delete :settings
end

Redmine::MenuManager.map :account_menu do |menu|
  menu.push :my_page, { :controller => 'my', :action => 'page' }, :if => Proc.new { User.current.logged? }, :before => :my_account
end

Redmine::MenuManager.map :application_menu do |menu|
  menu.push :state, :home_path
  menu.push :issues_calendar, { :controller => 'issues', :action => 'calendar' }
  menu.push :issues, { :controller => 'issues' }, :caption => :label_issue_plural
end

Redmine::MenuManager.map :project_right_menu do |menu|
  menu.push :settings, { :controller => 'projects', :action => 'settings' }
  menu.push :search, { :controller => 'search', :action => 'index' }
end

Redmine::MenuManager.map :application_right_menu do |menu|
  menu.push :admin, { :controller => 'admin', :action => 'index' }, :if => Proc.new { User.current.admin? }
  menu.push :search, { :controller => 'search', :action => 'index' }
end