class DashboardsController < ApplicationController
  expose(:project_mappings) { ProjectMapping.where(:created_by => current_user) }
end
