class KanbaneryUpdatesController < ApplicationController
  expose(:project_mapping) do
    case action_name
    when 'index'
      ProjectMapping.where(:created_by => current_user).find(params[:project_mapping_id])
    when 'create'
      ProjectMapping.where(:token => params[:token]).first!
    else
      raise "I don't know."
    end
  end

  expose(:kanbanery_updates) { project_mapping.kanbanery_updates.order('created_at desc').limit(20) }

  def create
    kanbanery_updates.create :body => params.to_json
    CampfireNotifier.new(project_mapping).notify(params)
    head :ok
  end
end
