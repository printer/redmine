class CreateDefaults < ActiveRecord::Migration
  def self.up
    Redmine::DefaultData::Loader::load('ru')
    
    project = Project.new(:name => 'Test', :identifier => 'test', :trackers => Tracker.all)
    project.enabled_module_names = Redmine::AccessControl.available_project_modules
    project.save
  end

  def self.down
  end
end
