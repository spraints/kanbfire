class ProjectMappingsController < ApplicationController
  expose(:project_mapping)

  def create
    project_mapping.created_by = current_user
    if project_mapping.save
      redirect_to root_path, :notice => 'Project mapping created!'
    else
      render 'new'
    end
  end

  def update
    if project_mapping.save
      redirect_to root_path, :notice => 'Project mapping updated!'
    else
      render 'edit'
    end
  end
end
