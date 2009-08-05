class IssuesController < ApplicationController
  unloadable
  
  menu_item :issues_calendar, :only => :calendar
end