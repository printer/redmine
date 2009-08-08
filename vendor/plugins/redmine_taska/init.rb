require 'redmine'
require 'dispatcher'

require 'taska/redmine/helpers/calendar'
require 'taska/redmine/i18n'
require 'taska/acts_as_activity_provider'
require 'taska/redmine/activity'
require 'taska/redmine/activity/fetcher'

ActionView::Base.send(:include, AdditionalMenuHelper)
ActionView::Base.send(:include, TaskaHelper)

Dispatcher.to_prepare do
  Redmine::Activity::Fetcher.send(:include, Redmine::Activity::FetcherPatch)
  
  Issue.send(:include, Taska::Issue)
  Journal.send(:include, Taska::Journal)
  Document.send(:include, Taska::Document)
  WikiContent.send(:include, Taska::WikiContent)
  Attachment.send(:include, Taska::Attachment)
  Changeset.send(:include, Taska::Changeset)
  Version.send(:include, Taska::Version)
end

Redmine::Plugin.register :redmine_taska do
  name 'Redmine Taska plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end

Redmine::Activity.clear

Redmine::Activity.map do |activity|
  activity.register :issues, :class_name => %w(Issue Journal)
  activity.register :changesets
  activity.register :news
  activity.register :documents, :class_name => %w(Document Attachment)
  activity.register :files, :class_name => 'Attachment'
  activity.register :wiki_edits, :class_name => 'WikiContent'
  activity.register :versions
  activity.register :messages, :default => false
end

Redmine::AccessControl.map do |map|
  map.permission :view_versions, {}, :public => true
end

Redmine::MenuManager.map :top_menu do |menu|
  menu.delete :projects
  menu.delete :administration
  menu.delete :help
  menu.delete :my_page
end

Redmine::MenuManager.map :project_menu do |menu|
  menu.delete :settings
  menu.delete :activity
  menu.delete :new_issue
  menu.delete :roadmap
  
  menu.push :roadmap, { :controller => 'projects', :action => 'roadmap' }, :after => :issues
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