class CampfireNotifier
  attr_reader :project_mapping

  def initialize project_mapping
    @project_mapping = project_mapping
  end

  def notify params
    say message_for(params)
  end

  def message_for(params)
    # With an API token for kanbanery, we could get some other goodies,
    # like the name of the user, project, etc.
    resource = params[:resource]
    '[kanbanery] ' +
      case resource[:type]
      when 'LoggedTaskEvent'
        "#{resource[:name].humanize} https://kanbanery.com/tasks/#{resource[:task_id]}/in-context"
      else
        "#{resource[:type]} #{resource[:id]} \"#{resource[:title]}\" was updated. #{resource[:global_in_context_url]}"
      end
  end

  def say message
    campfire_room.speak message
  end

  def campfire_room
    campfire.find_room_by_name(project_mapping.campfire_room_name) or raise "Could not find campfire room #{project_mapping.campfire_room_name}"
  end

  def campfire
    Tinder::Campfire.new project_mapping.campfire_subdomain,
      :token => project_mapping.campfire_token,
      :ssl => true
  end
end
