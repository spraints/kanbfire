class CreateKanbaneryUpdates < ActiveRecord::Migration
  def change
    create_table :kanbanery_updates do |t|
      t.belongs_to :project_mapping

      t.text :body

      t.timestamps
    end
  end
end
