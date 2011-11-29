class CreateProjectMappings < ActiveRecord::Migration
  def change
    create_table :project_mappings do |t|
      t.string :campfire_token, :campfire_room_name, :created_by, :token
      t.timestamps
    end
  end
end
