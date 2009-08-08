require_dependency 'issues_controller'

class IssuesController < ApplicationController
  unloadable
  
  menu_item :issues_calendar, :only => :calendar
  menu_item :issues, :only => :new
end