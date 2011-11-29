class AddCampfireSubdomainToProjectMappings < ActiveRecord::Migration
  def change
    add_column :project_mappings, :campfire_subdomain, :string
  end
end
