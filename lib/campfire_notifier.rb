require 'active_support/core_ext'

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
      when 'Task'
        if new? resource
          "Task #{resource[:id]} \"#{resource[:title]}\" added. #{resource[:global_in_context_url]}"
        else
          return false
        end
      when 'Comment'
        "Comment added to task #{resource[:task_id]}: \"#{resource[:body]}\" #{url_for resource[:task_id]}"
      when 'Blocking'
        "Task #{resource[:task_id]} is blocked! \"#{resource[:blocking_message]}\" #{url_for resource[:task_id]}"
      when 'Subtask'
        change =
          if new? resource
            "added"
          elsif resource[:completed] == 'true'
            "completed"
          else
            "updated"
          end
        "Subtask \"#{resource[:body]}\" #{change}. #{url_for resource[:task_id]}"
      when 'GitCommit', 'Column', 'LoggedTaskEvent'
        return false
      else
        "#{resource[:type].humanize}. #{url_for resource[:task_id]}"
      end
  end

  def new? resource
    resource[:created_at] == resource[:updated_at]
  end

  def url_for task_id
    task_id && "https://kanbanery.com/tasks/#{task_id}/in-context"
  end

  def say message
    if message
      if KanbfireConfig.no_campfire
        Rails.logger.info "MESSAGE FOR CAMPFIRE: #{message}"
      else
        campfire_room.speak message
      end
    end
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
