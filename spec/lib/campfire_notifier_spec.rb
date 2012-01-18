#require 'spec_helper'
require_relative '../../lib/campfire_notifier'

describe CampfireNotifier do
  context '#message_for' do
    subject { described_class.new(nil).message_for(params) }
    # The actual params include the following keys. We only include here what we need.
    #  :user_id => id of kanbanery user who made the change
    #  :auth_token => kanbanery's token associated with this live update hook
    #  :controller => 'kanbanery_updates'
    #  :action => 'create'
    #  :token => token assigned by kanbfire for the project mapping
    let(:params) { { :resource => resource.with_indifferent_access }.with_indifferent_access }

    context 'Task' do
      let(:resource) { { "type"=>"Task", "id"=>"12345", "global_in_context_url"=>"https://kanbanery.com/tasks/12345/in-context", "title"=>"Title of the task", "created_at"=>"2011-11-23T22:16:53+00:00", "updated_at"=>"2011-11-30T14:31:34+00:00", "description"=>"Description of task", "task_type_id"=>"44444", "column_id"=>"55555", "creator_id"=>"8765", "owner_id"=>"8765", "position"=>"2", "priority"=>"0", "ready_to_pull"=>"true", "moved_at"=>"2011-11-30T14:11:08+00:00", "blocked"=>"false" } }
      it { should == '[kanbanery] Task 12345 "Title of the task" updated. https://kanbanery.com/tasks/12345/in-context' }
    end

    context 'Comment' do
      let(:resource) { { "type"=>"Comment", "task_id"=>"12345", "body"=>"This is a comment body.", "id"=>"23456", "created_at"=>"2011-11-30T14:34:35+00:00", "updated_at"=>"2011-11-30T14:34:35+00:00", "author_id"=>"8765" } }
      it { should == '[kanbanery] Comment added to task 12345: "This is a comment body." https://kanbanery.com/tasks/12345/in-context' }
    end

    context 'LoggedTaskEvent' do
      let(:resource) { { "type"=>"LoggedTaskEvent", "name"=>"task_ready_to_pull", "task_id"=>"12345", "custom_attributes"=>"[\"task_type_name\", \"Feature\"]", "id"=>"deadbeef123456789abcdef0", "user_id"=>"8765", "created_at"=>"2011-11-30T14:31:34+00:00", "project_id"=>"7777", "column_id"=>"55555" } }
      it { should == '[kanbanery] Task ready to pull. https://kanbanery.com/tasks/12345/in-context' }
    end

    context 'Blocking' do
      let(:resource) { { "type"=>"Blocking", "task_id"=>"12345", "blocking_message"=>"This is why it is blocked.", "id"=>"3456", "created_at"=>"2011-11-30T14:34:59+00:00", "updated_at"=>"2011-11-30T14:34:59+00:00" } }
      it { should == '[kanbanery] Task 12345 is blocked! "This is why it is blocked." https://kanbanery.com/tasks/12345/in-context' }
    end

    context 'Column' do
      let(:resource) { { "id"=>"55555", "created_at"=>"2011-11-29T19:16:03+00:00", "updated_at"=>"2011-12-05T13:19:48+00:00", "project_id"=>"8765", "name"=>"My Column", "fixed"=>"false", "position"=>"3", "type"=>"Column" } }
      it { should == '[kanbanery] Column "My Column" modified.' }
    end

    context 'Gitcommit' do
      let(:resource) { { "id"=>"4784", "created_at"=>"2012-01-18T19:16:14+00:00", "updated_at"=>"2012-01-18T19:16:14+00:00","commit_id"=>"a1b2c37890abcdef1234567890abcdef12345678","message"=>"Commit message. #12345","url"=>"https://github.com/spraints/kanbfire/commit/a1b2c37890abcdef1234567890abcdef12345678","author_email"=>"author@example.com","author_name"=>"Author Name","timestamp"=>"2012-01-18T19:16:08+00:00","task_id"=>"12345","short_commit_id"=>"a1b2c3","gravatar_url"=>"https://secure.gravatar.com/avatar/example?s=10","type"=>"GitCommit" } }
      it { should == false }
    end

    context 'unknown event type' do
      let(:resource) { { "type" => "Something_Else" } }
      it { should == '[kanbanery] Something else. ' }
    end

    context 'unknown event type with task id' do
      let(:resource) { { "type" => "Something_Else", :task_id => "12345" } }
      it { should == '[kanbanery] Something else. https://kanbanery.com/tasks/12345/in-context' }
    end
  end
end
